# Alternate BnB #
## Contents: ##
  - [User stories](#user-stories)
  - [Initial Interface Design work](./docs/interface.md)

## User stories ##
### User story 1: ###
```
As a user,
In order to manage my spaces or bookings:
I would like to sign-up.
```
### User story 2: ###
```
As a host,
So that I can receive bookings,
I want to be able to list multiple spaces.
```
### User story 3: ###
```
As a host,
So that users can make a choice on a listing,
I want to be able to provide a name, description, and price.
```
### User story 4: ###
```
As a host,
So that users know when my listing is available,
I want to be able to provide a range of available dates.
```
### User story 5: ###
```
As a user,
So that I can book a listing,
I want to be able to request a hire, which should be approved by the host.
```
### User story 6: ###
```
As a user,
So that I know when a listing is available,
Nights which are not available should not be displayed to me.
```
### User story 7: ###
```
As a host,
So that I can have confidence in my booking,
I want to see the date unavailable once I confirm the booking.
```
### User story 8: ###
```
As a user,
So that I know when my booking is confirmed,
I want receive a text message with dates when my booking is confirmed.
```

## Domain model ##

#### Infrastructure
- Twilio API
- Some sort of email gem
- BCrypt
- Sinatra
- PostgreSQL
- Shotgun

#### Objects:
- User
- Listing
- Booking
- Communication Manager

#### Methods
- User:
  - sign_up
  - sign_in
  - Class:
    - all
    - find
    - status?
    - member?
    - check_login?
- Listing:
  - available_dates
  - check_availability?
  - Class:
    - all
    - find
- Booking:
  - create
  - confirmation
  - delete
  - edit (dates)
  - Class:
    - all
    - find (dates)
    - status?
- Communication manager:
  - Class:
    - send_text
    - send_email

### Properties:
- User:
  - username
  - ID
  - Phone number
  - Email address
- Listing:
  - Available dates
  - Name
  - Price
  - Description
  - Host ID
- Booking:
  - Listing
  - User ID
  - Date range
  - Price (sum)
  - Confirmed/status?

### Views:
- Homepage
  - Sign in/Sign up
- Manage Listing
  - Listing add
- Search(results)
- Manage Bookings
- Calendar
