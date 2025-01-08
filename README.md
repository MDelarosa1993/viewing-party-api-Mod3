# Viewing Party API

Viewing Party API is an API-only Rails application that allows users to create and manage viewing parties for movies. It integrates with a third-party movie service to fetch movie details and supports features like user authentication and invitee management.

## Features

- **User Authentication:** Secure login and API key generation using `bcrypt`.
- **Movie Integration:** Search and fetch movie details using the Movie Service.
- **Viewing Party Management:** Create and manage viewing parties with runtime checks and invitees.
- **RESTful API Endpoints:** Structured routes for users, sessions, movies, and viewing parties.

## Installation

### Prerequisites
- Ruby 3.2.2
- Rails 7.1.3
- PostgreSQL

### Steps
1. Clone the repository:
   ```bash
   git clone git@github.com:MDelarosa1993/viewing-party-api-Mod3.git
   cd viewing_party_api
   ```
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Set up the database:
   ```bash
   rails db:create db:migrate
   ```
4. Start the Rails server:
   ```bash
   rails server
   ```

## Database Schema

### Users Table
- `id`: Primary key
- `name`: String
- `username`: String (unique)
- `password_digest`: String
- `api_key`: String (unique)
- Timestamps: `created_at`, `updated_at`

### Viewing Parties Table
- `id`: Primary key
- `name`: String (unique)
- `start_time`: Datetime
- `end_time`: Datetime
- `movie_id`: Integer
- `movie_title`: String
- `host_id`: Foreign key (User)
- Timestamps: `created_at`, `updated_at`

### Viewing Party Users Table
- `id`: Primary key
- `viewing_party_id`: Foreign key (Viewing Party)
- `user_id`: Foreign key (User)
- Timestamps: `created_at`, `updated_at`

## API Endpoints

### Users
- `POST /api/v1/users`: Create a new user.
- `GET /api/v1/users`: Retrieve a list of all users.

### Sessions
- `POST /api/v1/sessions`: Login and retrieve API key.

### Movies
- `GET /api/v1/movies`: Fetch top-rated movies or search by query.
- `GET /api/v1/movies/:id`: Retrieve details of a specific movie.

### Viewing Parties
- `POST /api/v1/viewing_parties`: Create a new viewing party.
- `GET /api/v1/viewing_parties`: Retrieve all viewing parties.
- `PATCH /api/v1/viewing_parties/:id`: Update viewing party invitees.

## Key Gems

- `bcrypt`: Secure password handling.
- `faraday`: HTTP client for external API requests.
- `jsonapi-serializer`: JSON serialization for API responses.
- `rspec-rails`: Testing framework.
- `shoulda-matchers`: Testing matchers for Rails models and controllers.
- `webmock` and `vcr`: Mock and record HTTP requests during testing.

## Testing

Run the test suite using:
```bash
bundle exec rspec
```

- Code coverage is handled by `simplecov`.
- External API requests are mocked using `webmock` and `vcr`.

## API Documentation

### Example: Create Viewing Party
#### Request
```http
POST /api/v1/viewing_parties
Content-Type: application/json
Authorization: Bearer <api_key>

{
  "name": "Avengers Party",
  "start_time": "2025-01-10T18:00:00Z",
  "end_time": "2025-01-10T21:00:00Z",
  "movie_id": 12345,
  "movie_title": "Avengers: Endgame",
  "invitees": [2, 3]
}
```
#### Response
```json
{
  "data": {
    "id": "1",
    "type": "viewing_party",
    "attributes": {
      "name": "Avengers Party",
      "start_time": "2025-01-10T18:00:00Z",
      "end_time": "2025-01-10T21:00:00Z",
      "movie_id": 12345,
      "movie_title": "Avengers: Endgame",
      "host_id": 1
    }
  }
}
```

## Future Enhancements

- Add user authentication for endpoints using JWT.
- Implement email notifications for invitees.
- Add pagination for large datasets.

