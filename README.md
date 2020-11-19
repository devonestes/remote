# UserPoints

## Getting Started

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Run the tests with `mix test`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## API Schema

### User

`User` represents a user in the system, and has the following schema:

```
{
  "id": integer,
  "points": integer
}
```

## Endpoint Documentation

### `GET /`

Returns a list of no more than two users who have a number of `points` higher than the current
minimum number of points in the application, as well as the timestamp of the last call to this
endpoint (in Unix seconds).

**Schema**
```
{
  "timestamp": integer,
  "users": [User]
}
```

**Example**

```
{
  "timestamp": 1605804004,
  "users": [
    {
      "id": 1,
      "points": 38
    },
    {
      "id": 2,
      "points": 57
    }
  ]
}
```
