namespace :heatmap do
  desc "Generate heatmap grid data for London area"
  task generate: :environment do
    puts "Generating heatmap grid for London area..."

    # Define London bounds (roughly covering Greater London and surrounding areas)
    # These coordinates cover from roughly Windsor to Southend, and Watford to Croydon
    min_lat = 51.2
    max_lat = 51.7
    min_lng = -0.6
    max_lng = 0.4

    # Grid resolution: approximately 100m at London's latitude
    # 1 degree latitude ≈ 111km
    # 1 degree longitude at 51.5°N ≈ 69km
    lat_step = 0.1 / 111.0  # ~100m
    lng_step = 0.1 / 69.0   # ~100m

    grid_data = []
    max_score = Scorecard.max_score
    total_points = ((max_lat - min_lat) / lat_step).ceil * ((max_lng - min_lng) / lng_step).ceil
    processed = 0

    lat = min_lat
    while lat <= max_lat
      lng = min_lng
      while lng <= max_lng
        begin
          scorecard = Scorecard.new(lat, lng)
          score = scorecard.total_points
          percentage = ((score.to_f / max_score.to_f) * 100).round(1)

          # Only include points with score > 0 to reduce file size
          if score > 0
            # Store as compact array instead of hash to save space
            # Format: [lat, lng, percentage]
            grid_data << [
              lat.round(6),
              lng.round(6),
              percentage.round(1)
            ]
          end

          processed += 1
          if processed % 100 == 0
            puts "Processed #{processed}/#{total_points} points (#{(processed.to_f / total_points * 100).round(1)}%)"
          end
        rescue => e
          puts "Error at #{lat}, #{lng}: #{e.message}"
        end

        lng += lng_step
      end
      lat += lat_step
    end

    # Create public/data directory if it doesn't exist
    FileUtils.mkdir_p(Rails.root.join('public', 'data'))

    # Write to JSON file (compact format without pretty printing to save space)
    output_file = Rails.root.join('public', 'data', 'heatmap.json')
    File.write(output_file, JSON.generate({
      meta: {
        generated_at: Time.current.iso8601,
        max_score: max_score,
        grid_resolution_m: 100,
        bounds: [min_lat, max_lat, min_lng, max_lng]
      },
      # Points stored as arrays: [lat, lng, percentage]
      points: grid_data
    }))

    puts "\nHeatmap generation complete!"
    puts "Total points with scores: #{grid_data.length}"
    puts "Output file: #{output_file}"
    puts "File size: #{(File.size(output_file).to_f / 1024 / 1024).round(2)} MB"
  end
end
