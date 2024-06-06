CREATE DATABASE HomeSync

USE HomeSync

CREATE TABLE Room(
	room_id INT,
	type VARCHAR(50),
	floor INT,
	status VARCHAR(40),

	PRIMARY KEY(room_id)
);

CREATE TABLE Users(
	user_id INT IDENTITY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	password VARCHAR(10),
	email VARCHAR(50),
	preference VARCHAR(40),
	room INT,
	type VARCHAR(50) DEFAULT 'Guest',
	birthdate DATE,
	age AS (YEAR(CURRENT_TIMESTAMP) - YEAR(birthdate)),
	
	PRIMARY KEY(user_id),
	FOREIGN KEY (room) REFERENCES Room ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Admin(
	admin_id INT,
	no_of_guests_allowed INT DEFAULT 30,
	salary DECIMAL(13,2),

	PRIMARY KEY(admin_id),
	FOREIGN KEY(admin_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Guest(
	guest_id INT,
	guest_of INT,
	address VARCHAR(80),
	arrival_date DATETIME,
	departure_date DATETIME,
	residential VARCHAR(80),

	PRIMARY KEY(guest_id),
	FOREIGN KEY(guest_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(guest_of) REFERENCES Admin
);

CREATE TABLE Tasks(
	task_id INT IDENTITY,
	name VARCHAR(80),
	creation_date DATETIME,
	due_date DATETIME,
	category VARCHAR(80),
	creator INT,
	status VARCHAR(50),
	reminder_date DATETIME,
	priority INT,

	PRIMARY KEY(task_id),
	FOREIGN KEY(creator) REFERENCES Admin ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Assigned_to(
	admin_id INT NOT NULL,
	task_id INT NOT NULL,
	user_id INT,

	CONSTRAINT [PK_Assigned_to] PRIMARY KEY CLUSTERED (task_id, user_id, admin_id),
	FOREIGN KEY(user_id) REFERENCES Users ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(task_id) REFERENCES Tasks,
	FOREIGN KEY(admin_id) REFERENCES Admin(admin_id) 
);

CREATE TABLE Calender(
	event_id INT IDENTITY,
	user_assigned_to INT,
	name VARCHAR(80),
	description VARCHAR(80),
	location VARCHAR(100), 
	reminder_date DATETIME,

	PRIMARY KEY(event_id,user_assigned_to),
	FOREIGN KEY(user_assigned_to) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Notes(
	note_id INT IDENTITY,
	user_id INT,
	content VARCHAR(100),
	creation_date DATETIME,
	title VARCHAR(50),

	PRIMARY KEY(note_id),
	FOREIGN KEY (user_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Travel(
	trip_no INT,
	hotel_name VARCHAR(50),
	destination VARCHAR(60),
	ingoing_flight_num INT,
	outgoing_flight_num INT,
	ingoing_flight_date DATETIME,
	outgoing_flight_date DATETIME,
	ingoing_flight_airport VARCHAR(50),
	outgoing_flight_airport VARCHAR(50),
	transport VARCHAR(50),

	PRIMARY KEY(trip_no)
);

CREATE TABLE User_trip(
	trip_no INT NOT NULL,
	user_id INT NOT NULL,
	hotel_room_no INT,
	in_going_flight_seat_number INT,
	out_going_flight_seat_number INT,

	PRIMARY KEY(trip_no,user_id),
	FOREIGN KEY(trip_no) REFERENCES Travel ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(user_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Finance(
	payement_id INT IDENTITY PRIMARY KEY,
	user_id INT,
	type VARCHAR(50),
	amount DECIMAL(13,2),
	currency VARCHAR(30),
	method VARCHAR(60),
	status VARCHAR(50),
	date DATE,
	receipt_no INT,
	deadline DATETIME,
	penalty VARCHAR(50),

	FOREIGN KEY(user_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Health(
	date DATETIME NOT NULL,
	activity VARCHAR(30) NOT NULL,
	user_id INT, 
	hours_slept INT,
	description VARCHAR(70),
	food VARCHAR(60),
	
	CONSTRAINT [PK_Health] PRIMARY KEY CLUSTERED (date, activity),
	FOREIGN KEY(user_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Communication(
	message_id INT IDENTITY,
	sender_id INT,
	receiver_id INT , 
	content VARCHAR(50),
	time_sent DATETIME,
	time_received DATETIME,
	time_read DATETIME,
	title VARCHAR(60),

	PRIMARY KEY(message_id),
	FOREIGN KEY(sender_id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY(receiver_id) REFERENCES Users
);


CREATE TABLE Device(
	device_id INT,
	room INT,
	type VARCHAR(50),
	status VARCHAR(50),
	battery_status INT,

	PRIMARY KEY(device_id),
	FOREIGN KEY(room) REFERENCES Room ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE RoomSchedule (
	creator_id INT,
	action VARCHAR(50),
	room INT,
	start_time DATETIME,
	end_time DATETIME,

	PRIMARY KEY(creator_id, start_time),
	FOREIGN KEY(creator_id) REFERENCES Users ON DELETE CASCADE,
	FOREIGN KEY(room) REFERENCES Room ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Log (
	room_id INT,
	device_id INT NOT NULL,
	user_id INT NOT NULL,
	activity VARCHAR(50),
	date DATETIME NOT NULL,
	duration VARCHAR(70),

	CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED (room_id, device_id, user_id, date),
	FOREIGN KEY(room_id) REFERENCES Room ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY(device_id) REFERENCES Device ON DELETE CASCADE,
	FOREIGN KEY(user_id) REFERENCES Users
);

CREATE TABLE Consumption(
	device_id INT NOT NULL,
	consumption INT,
	date DATETIME NOT NULL,

	CONSTRAINT [PK_Consumption] PRIMARY KEY CLUSTERED (device_id, date),
	FOREIGN KEY(device_id) REFERENCES Device ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Preferences (
	user_id INT,
	category VARCHAR(50),
	preference_no INT,
	content VARCHAR(80),

	CONSTRAINT [PK_Preferences] PRIMARY KEY CLUSTERED (user_id, preference_no),
	FOREIGN KEY(user_id) REFERENCES Users ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Recommendation (
	recommendation_id INT PRIMARY KEY IDENTITY,
	user_id INT,
	category VARCHAR(50),
	preference_no INT,
	content VARCHAR(50),

	FOREIGN KEY(user_id, preference_no) REFERENCES Preferences(user_id, preference_no) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE Inventory(
	supply_id INT PRIMARY KEY,
	name VARCHAR(50),
	quantity INT,
	expiry_date DATETIME,
	price decimal(13,2),
	manufacturer VARCHAR(50),
	category VARCHAR(50)
);


CREATE TABLE Camera(
    monitor_id INT NOT NULL,
    camera_id INT NOT NULL,
	status VARCHAR(50),
	room_id INT,

    CONSTRAINT PK_Camera PRIMARY KEY (monitor_id, camera_id),
	FOREIGN KEY(room_id) REFERENCES Room ON DELETE CASCADE ON UPDATE CASCADE 
);
