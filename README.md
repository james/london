# How London Are You?

The application behind https://london.abscond.org

## What Makes a Place "London"?

The border of London is surprisingly complicated. Different people have different interpretations of where London ends. This application calculates a composite score based on:

- **London Boroughs** - Are you within an official London borough?
- **Tube Stations** - How close are you to the Underground? Which zone?
- **Night Tube** - Can you get a late-night tube home?
- **Cycle Docks** - How close is the nearest Santander bike?
- **Pret A Manger** - The unofficial marker of urban London density
- **PTAL (Public Transport Accessibility Level)** - Official TfL measure of transport access

Generally, the more central you are, the higher your score. However, the presence of a Pret means you might score "slightly London" even if you're in Edinburgh.

## How It Works

1. Enter a UK postcode
2. The application geocodes it to latitude/longitude coordinates
3. A `Scorecard` calculates scores based on proximity to various London markers
4. You receive a percentage score and detailed breakdown

The maximum possible score is calibrated from a central London location (around Liverpool Street).

## Technology Stack

- **Ruby on Rails 7.1.3** - Web framework
- **PostgreSQL with PostGIS** - Geospatial database
- **Hotwire (Turbo + Stimulus)** - Modern frontend interactivity
- **DartSass** - CSS compilation

## Getting Started

### Prerequisites

- Ruby 3.3.0
- PostgreSQL with PostGIS extension
- Bundler

### Installation

1. Clone the repository:

   ```bash
   git clone [repository-url]
   cd london
   ```

2. Install dependencies:

   ```bash
   bundle install
   ```

3. Set up the database:

   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails data:migrate  # Imports geospatial data
   ```

4. Start the development server:

   ```bash
   bin/dev
   ```

5. Visit `http://localhost:3000` and start exploring!

### Geospatial Data

The application includes data migrations that import:

- London borough boundaries (GeoJSON)
- Tube station locations and zones
- Night tube stations
- Santander cycle dock locations
- Pret A Manger locations
- PTAL (Public Transport Accessibility Level) data points

Data files are located in the `/geojson/` directory.

## Development

### Running Tests

```bash
bundle exec rspec
```

### Useful Commands

- `bin/rails console` - Open Rails console to explore data
- `bin/rails db:migrate` - Run database migrations
- `bin/rails data:migrate` - Run data migrations (imports geo data)
- `bin/rails dartsass:build` - Compile SCSS files

### Project Structure

- `app/models/scorecard.rb` - Core scoring logic
- `app/models/scorers/` - Individual scoring strategies
- `app/models/concerns/london_point.rb` - Shared geospatial query methods
- `app/controllers/searches_controller.rb` - Postcode lookup endpoint
- `db/data/` - Data migration scripts for importing geographic data
- `geojson/` - Source geographic data files

## How Scoring Works

The `Scorecard` class orchestrates multiple scorer classes, each evaluating different aspects:

1. **AreaScorer** - Points for being within London boroughs
2. **TubeScorer** - Points based on tube zone proximity
3. **NightTubeScorer** - Bonus points for night tube access
4. **CycleDockScorer** - Points for nearby cycle hire
5. **PretScorer** - Points for Pret proximity
6. **PtalScorer** - Points from Transport for London accessibility data

Each scorer returns individual `Score` objects with points, which are summed for the total. The percentage is calculated against the maximum possible score from a central London reference point.

## Deployment

The application is configured for deployment on Fly.io. Configuration is in `fly.toml`.

### Environment Variables

- `SENTRY_DSN` - (Optional) Sentry error tracking

## Contributing

Pull requests welcome!
