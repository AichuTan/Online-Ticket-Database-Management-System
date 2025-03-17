DROP DATABASE IF EXISTS TicketReservationSystem;
CREATE DATABASE TicketReservationSystem;
USE TicketReservationSystem;


CREATE TABLE User (
    UserID INT PRIMARY KEY,
    UserType ENUM('Individual', 'Company', 'Organizer') NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Address TEXT
);

CREATE TABLE IndividualCustomer (
    UserID INT PRIMARY KEY,
    CustomerName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE CorporateCustomer (
    UserID INT PRIMARY KEY,
    CompanyName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Organizer (
    UserID INT PRIMARY KEY,
    OrganizerName VARCHAR(100) NOT NULL,
    ContactName VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES User(UserID) ON DELETE CASCADE
);

CREATE TABLE Event (
    EventID INT PRIMARY KEY,
    EventName VARCHAR(100) NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    UserID INT NOT NULL,
    BasePrice DECIMAL(10,2) NOT NULL CHECK (BasePrice >= 0),
	CONSTRAINT unique_event UNIQUE (EventName, Date),
    FOREIGN KEY (UserID) REFERENCES Organizer(UserID) ON DELETE CASCADE
);


CREATE TABLE EventVenue (
    EventID INT NOT NULL,
    VenueID INT NOT NULL,
    PRIMARY KEY (EventID, VenueID),
    FOREIGN KEY (EventID) REFERENCES Event(EventID) 
		ON DELETE RESTRICT 
		ON UPDATE RESTRICT ,
    FOREIGN KEY (VenueID) REFERENCES Venue(VenueID) 
		ON DELETE RESTRICT 
		ON UPDATE RESTRICT 
);

CREATE TABLE Venue (
    VenueID INT PRIMARY KEY,
    VenueName VARCHAR(100) NOT NULL,
    Location VARCHAR(255) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity > 0)
);

CREATE TABLE Booking (
    BookingID INT PRIMARY KEY,
    UserID INT NOT NULL,
    EventID INT NOT NULL,
    BookingType ENUM('Individual', 'Group') NOT NULL,
    BookingDate DATE NOT NULL,
    TotalPrice DECIMAL(10,2) NOT NULL,
    DiscountID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID) 
		ON DELETE CASCADE,
    FOREIGN KEY (EventID) REFERENCES Event(EventID) 
		ON DELETE CASCADE,
	FOREIGN KEY (DiscountID) REFERENCES Discount(DiscountID) 
		ON DELETE SET NULL
);

CREATE TABLE Discount (
    DiscountID INT PRIMARY KEY,
    DiscountSource ENUM('Company', 'Groupon', 'Promotion') NOT NULL,
    DiscountPercentage DECIMAL(5,2) NOT NULL CHECK (DiscountPercentage BETWEEN 0 AND 100)
);

CREATE TABLE Payment (
    PaymentID INT PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    FOREIGN KEY(BookingID) REFERENCES Booking(BookingID) 
		ON DELETE RESTRICT 
		ON UPDATE RESTRICT
);

CREATE TABLE Seat (
    SeatID INT NOT NULL PRIMARY KEY,
    VenueID INT NOT NULL,
    RowNumber VARCHAR(5) NOT NULL,
    SeatNumber INT NOT NULL,
    Category ENUM('VIP', 'Regular', 'Economy') NOT NULL,
	FOREIGN KEY (VenueID) REFERENCES Venue(VenueID) ON DELETE CASCADE
);

CREATE TABLE BookingSeat (
    BookingID INT NOT NULL,
    SeatID INT NOT NULL,
    PRIMARY KEY (BookingID, SeatID),
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID) 
		ON DELETE CASCADE,
    FOREIGN KEY (SeatID) REFERENCES Seat(SeatID) 
		ON DELETE CASCADE 
);
