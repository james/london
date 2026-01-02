require 'chunky_png'

namespace :heatmap do
  desc "Generate rasterized heatmap image from JSON data"
  task image: :environment do
    puts "Loading heatmap data..."

    json_file = Rails.root.join('public', 'data', 'heatmap.json')
    unless File.exist?(json_file)
      puts "Error: heatmap.json not found. Run 'rake heatmap:generate' first."
      exit 1
    end

    data = JSON.parse(File.read(json_file))
    points = data['points']
    bounds = data['meta']['bounds']

    min_lat, max_lat, min_lng, max_lng = bounds

    puts "Creating heatmap image with #{points.length} points..."

    # Image dimensions (pixels per degree)
    # Higher values = higher resolution but larger file
    pixels_per_degree_lat = 11100  # ~100m per pixel at this resolution
    pixels_per_degree_lng = 6900   # ~100m per pixel at London's latitude

    width = ((max_lng - min_lng) * pixels_per_degree_lng).ceil
    height = ((max_lat - min_lat) * pixels_per_degree_lat).ceil

    puts "Image size: #{width}x#{height} pixels"

    # Create image with transparent background
    image = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)

    # Draw each point as a filled rectangle
    points.each_with_index do |point, index|
      lat, lng, percentage = point

      # Convert lat/lng to pixel coordinates
      # Note: Image coordinates are top-left origin, but lat increases upward
      x = ((lng - min_lng) * pixels_per_degree_lng).round
      y = ((max_lat - lat) * pixels_per_degree_lat).round  # Flip Y axis

      # Get color for this percentage
      color = get_color(percentage)

      # Draw a small rectangle (approximately 100m x 100m)
      rect_size = 10  # pixels
      (0...rect_size).each do |dy|
        (0...rect_size).each do |dx|
          px = x + dx
          py = y + dy
          if px >= 0 && px < width && py >= 0 && py < height
            image[px, py] = color
          end
        end
      end

      if (index + 1) % 1000 == 0
        puts "Processed #{index + 1}/#{points.length} points (#{((index + 1).to_f / points.length * 100).round(1)}%)"
      end
    end

    # Save the image
    output_file = Rails.root.join('public', 'data', 'heatmap.png')
    image.save(output_file, :fast_rgba)

    # Also save metadata about the image bounds
    metadata_file = Rails.root.join('public', 'data', 'heatmap_bounds.json')
    File.write(metadata_file, JSON.generate({
      bounds: bounds,
      image_width: width,
      image_height: height
    }))

    puts "\nHeatmap image generation complete!"
    puts "Output file: #{output_file}"
    puts "File size: #{(File.size(output_file).to_f / 1024 / 1024).round(2)} MB"
  end

  private

  def get_color(percentage)
    # Same color scheme as JavaScript, but with alpha channel
    alpha = (0.6 * 255).round  # 60% opacity

    if percentage < 20
      ChunkyPNG::Color.rgba(0, 255, 0, alpha)      # Green
    elsif percentage < 40
      ChunkyPNG::Color.rgba(136, 255, 0, alpha)    # Yellow-green
    elsif percentage < 60
      ChunkyPNG::Color.rgba(255, 221, 0, alpha)    # Yellow
    elsif percentage < 80
      ChunkyPNG::Color.rgba(255, 136, 0, alpha)    # Orange
    else
      ChunkyPNG::Color.rgba(255, 0, 0, alpha)      # Red
    end
  end
end
