![logo_2x](https://github.com/mikeheft/route_rater/assets/25080717/533c3d8e-79dc-40cb-af6a-56d3489f2b03)

# README

# RouteRater

[ApiReview](https://docs.google.com/document/d/1EIruijeCCnIcu7I0AWO1ic397ll4yv2Fh5NWU4cgFlY/edit#heading=h.mqfjv3fbg3fa)

> In order to attract and retain Care Drivers we need to ensure that they are able to maximize their profits on any given day

## Prequisites
- `ruby 3.3.0`
- `rails 7.1.3.4`
- `postgres 16.1`

## Usage
### Setup
_Be sure to get the environment variables from Marlene. You will need the `GOOGLE_API_KEY` to geocode the routes_

- Clone repo: `git clone git@github.com:mikeheft/route_rater.git`
- Cd into directory: `cd route_rater`
- Install dependencies: `bundle isntall`
- Setup DataBase: `bundle exec rails db:create db:migrate db:seed`
- Run test suite: `bundle exec rspec`
- Start the app: `./app_start.sh`
    - This will start the redis server in daemonize mode, `redis-server --daemonize yes` and then the rails server. The default port is `3000` but you may still configure it as needed with the same option of `-p <PORT NUMBER>`

## API

The current flow of this application is based on a list of drivers (`/drivers`), where you may see the rides available for a driver to select (`/drivers/:driver_id/selectable_rides`). A ride is deemed selectable when there is no driver attached.

For the sake of speed the Drivers, Addresses, and Rides are all created via the seeds file. As the parameters of the assignment are to display a list of rides for a given driver we do not have the functionality to create more records, or any additional functionality.

To see the endpoints in action, after starting the rails server with `./app_start.sh`, navigate to `http://localhost:3000/drivers` to view the drivers or `http://localhost:3000/drivers/:driver_id/selectable_rides` to view the ranked rides

In order to more easily show API pagination, the default pagination params are set to a limit of 2 and offset of 0. To see the next set of records, simply add one to the offset, e.g., `/drivers?limit=2&offset=1`.

### Drivers
This endpoint shows all 'registered' drivers.

```json
// GET /drivers
{
  "data": [
    {
      "id": "21",
      "type": "driver",
      "attributes": {
        "id": 21,
        "full_name": "Elina Shields"
      },
      "relationships": {
        "current_address": {
          "data": {
            "id": "40",
            "type": "address"
          }
        }
      }
    },
    {
      "id": "22",
      "type": "driver",
      "attributes": {
        "id": 22,
        "full_name": "Tanja Marquardt"
      },
      "relationships": {
        "current_address": {
          "data": {
            "id": "41",
            "type": "address"
          }
        }
      }
    }
  ]
}
```

### Rides
The type for these are defined as `"pre-ride"` as they are what has been 'scheduled' and waiting for a driver to select. My thoughts on this are that once a driver selects a ride, that ride will have all of the corresponding data updated, e.g., duration, distance, commute_duration, driver_id.

The reasoning for this is because the `commute_duration` and `ride duration` are variable depending on the driver looking at the available rides and the durations can change depending on traffic.

The selectable rides are scoped to a pre determined 'radius' that is set on Driver creation. This is outlined in the [ApiReview](https://docs.google.com/document/d/1EIruijeCCnIcu7I0AWO1ic397ll4yv2Fh5NWU4cgFlY/edit#heading=h.mqfjv3fbg3fa).

```json
// GET /drivers/:driver_id/selectable_rides
{
  "data": [
    {
      "id": "81",
      "type": "pre-ride",
      "attributes": {
        "distance": "43 feet",
        "duration": "3 minutes",
        "commute_duration": "3 minutes",
        "ride_earnings": "$12.00"
      },
      "relationships": {
        "from_address": {
          "data": {
            "id": "46",
            "type": "address"
          }
        },
        "to_address": {
          "data": {
            "id": "51",
            "type": "address"
          }
        }
      }
    },
    {
      "id": "60",
      "type": "pre-ride",
      "attributes": {
        "distance": "8.64 miles",
        "duration": "14 minutes",
        "commute_duration": "1 minute",
        "ride_earnings": "$24.95"
      },
      "relationships": {
        "from_address": {
          "data": {
            "id": "42",
            "type": "address"
          }
        },
        "to_address": {
          "data": {
            "id": "49",
            "type": "address"
          }
        }
      }
    }
  ],
  "included": [
    {
      "id": "46",
      "type": "address",
      "attributes": {
        "id": 46,
        "line_1": "1024 S Lemay Ave",
        "line_2": null,
        "city": "Fort Collins",
        "state": "Co",
        "zip_code": "80524",
        "full_address": "1024 S Lemay Ave, Fort Collins, Co, 80524"
      }
    },
    {
      "id": "51",
      "type": "address",
      "attributes": {
        "id": 51,
        "line_1": "6609 Desert Willow Way",
        "line_2": "Unit 1",
        "city": "Fort Collins",
        "state": "Co",
        "zip_code": "80525",
        "full_address": "6609 Desert Willow Way, Unit 1, Fort Collins, Co, 80525"
      }
    },
    {
      "id": "42",
      "type": "address",
      "attributes": {
        "id": 42,
        "line_1": "2315 E Harmony Rd Suite 110",
        "line_2": null,
        "city": "Fort Collins",
        "state": "Co",
        "zip_code": "80528",
        "full_address": "2315 E Harmony Rd Suite 110, Fort Collins, Co, 80528"
      }
    },
    {
      "id": "49",
      "type": "address",
      "attributes": {
        "id": 49,
        "line_1": "3397 Wagon Trail Rd",
        "line_2": null,
        "city": "Fort Collins",
        "state": "Co",
        "zip_code": "80524",
        "full_address": "3397 Wagon Trail Rd, Fort Collins, Co, 80524"
      }
    }
  ]
}
```
