# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

The border of London is a suprisingly complicated thing. Different people have different interpretations of where London ends.

This is a Ruby on Rails 7.1.3 application that takes a UK postcode, and provides a "percentage" that that location is "within London". This is calculated based on proximity to various amenities and services. Users enter a postcode and receive a scored breakdown of their location's quality based on factors like tube stations, cycle docks, Pret locations, public transport accessibility levels (PTAL), and borough classifications.

Generally, the more central London you are, the higher your score will be, and it will lower as you get further away. However, some things, like Pret A Manger locations means you might be slightly in London even if you are in Edinburgh.

## Development Setup

### Prerequisites
- Ruby 3.3.0
- PostgreSQL with PostGIS extension
- Bundler

### Initial Setup
```bash
# Install dependencies
bundle install

# Setup database (requires PostgreSQL with PostGIS)
bin/rails db:create
bin/rails db:migrate
bin/rails data:migrate  # Import geospatial data

# Start development server
bin/dev
```

### Development Commands
- `bin/rails server` - Start Rails server on port 3000
- `bin/rails console` - Open Rails console
- `bin/rails db:migrate` - Run database migrations
- `bin/rails data:migrate` - Run data migrations (imports geospatial data)
- `bin/dev` - Start development server with CSS compilation (uses Procfile.dev)
- `rspec` - Run test suite (RSpec)
- `bin/rails dartsass:watch` - Watch and compile SCSS files

## Architecture

### Core Scoring System
The application centers around the `Scorecard` class which calculates location scores:

- **Scorecard** (`app/models/scorecard.rb`): Main scoring logic that evaluates a lat/lng coordinate
- **Score** (same file): Individual score components (tube zones, boroughs, amenities)

### Geographic Data Models
All models use PostGIS for geospatial queries:

Polygons:
- **LondonArea**: Borough and administrative area boundaries with scoring values

Points:
- **TubeStation**: London Underground stations with zone information and night tube flag
- **CycleDock**: Cycle hire docking stations
- **Pret**: Pret A Manger locations
- **PtalValue**: Public Transport Accessibility Level data points

### Geospatial Functionality
- **LondonPoint concern**: Shared module providing `find_nearest()`, `within_radius()`, and `distance_from()` methods
- Uses PostGIS functions: `ST_Contains()`, `ST_Distance()`, `ST_DWithin()`, `ST_GeomFromText()`
- All coordinates stored as PostGIS geography types in SRID 4326

### Data Import System
- Uses `data_migrate` gem for importing geospatial datasets
- Data files located in `/geojson/` (GeoJSON and CSV formats)
- Import scripts in `/db/data/` create and populate geographic models

### Frontend
- Rails 7 with Hotwire (Turbo + Stimulus)
- Single page application displaying postcode lookup and scoring results
- Uses importmap for JavaScript modules
- SCSS compiled with DartSass

## Testing

- **Framework**: RSpec
- **Test Structure**: 
  - `/spec/models/` - Model tests
  - `/spec/requests/` - Controller/integration tests  
  - `/spec/scorecard_spec.rb` - Core scoring logic tests
- **External Dependencies**: Uses WebMock for HTTP request stubbing

## Database

- **Primary**: PostgreSQL with PostGIS extension
- **Adapter**: `activerecord-postgis-adapter`
- **Key Extensions**: PostGIS for geographic data types and spatial queries
- **Schema**: Uses `postgis` adapter, geography columns for coordinate storage

## Deployment

- **Platform**: Fly.io
- **Config**: `fly.toml` configuration file
- **CI/CD**: GitHub Actions workflow deploys on main branch pushes
- **Health Check**: `/up` endpoint for load balancer monitoring