USE HomeSync;

DECLARE @user_id INT;
EXEC UserRegister 'Admin','abcd', 'abc@gmail.com', 'cd','2-1-2001', '123456', @user_id OUTPUT;
PRINT @user_id;

DECLARE @success BIT, @user_id INT;
EXEC userLogin 'bob@gmail.com', '123456', @success OUTPUT, @user_id OUTPUT;
PRINT 'success: ' + CAST(@success AS VARCHAR(10));
PRINT 'user ID: ' + CAST(@user_id AS VARCHAR(20));

DECLARE @success BIT, @user_id INT;
EXEC userLogin 'chad@gmail.com', '9876', @success OUTPUT, @user_id OUTPUT;
PRINT 'success: ' + CAST(@success AS VARCHAR(10));
PRINT 'user ID: ' + CAST(@user_id AS VARCHAR(20));

EXEC ViewProfile 2;

EXEC ViewRooms 18, 3;
EXEC ViewRooms NULL, 4;
EXEC ViewRooms 20, NULL;

EXEC ViewMyTask 1900;

EXEC FinishMyTask 19291, 'Task 1';
SELECT * FROM Tasks;

EXEC ViewTask 1452, 1900;

DECLARE @charge INT, @location INT;
EXEC ViewMyDeviceCharge 5, @charge OUTPUT, @location OUTPUT;
PRINT @charge;
PRINT @location;

EXEC AssignRoom 1900, 1500;
SELECT * FROM Users;

EXEC CreateEvent 4, 'Event Event', 'Event 12345', 'under the bridge', '11/23/2023', 1;
SELECT * FROM Calender;

EXEC AssignUser 5, 2;

EXEC AddReminder 2, '2/3/2024';
SELECT * FROM Tasks;

EXEC Uninvited 2, 5;

EXEC UpdateTaskDeadline '5/2/2024', 2;

EXEC ViewEvent 1, 4;
EXEC ViewEvent 1, 5;

EXEC ViewRecommendation;

EXEC CreateNote 3, 'Note 1', 'ABCD', '11/23/2023';
SELECT * FROM Notes;

EXEC ReceiveMoney 3, 'Fees 1', 75000, 'Uni Fees 1', '11/23/2023';
SELECT * FROM Finance;

EXEC PlanPayment 3, 1, 100000, 'Aid 111', '11/23/2024';

EXEC SendMessage 3, 2, 'Msg 1', 'Hello', '6:45:00', '6:50:00';
SELECT * FROM Communication;

EXEC NoteTitle 3, 'Updated Note';
EXEC NoteTitle @user_id = 3, @note_title = 'Birthday plans';

EXEC ShowMessages 2, 3;

EXEC ViewUsers 'Admin';
EXEC ViewUsers 'Guest';

EXEC RemoveEvent 1000, 1101;
SELECT * FROM Calender;

EXEC CreateSchedule 1900, 1300, '2/2/2023', '5/2/2023', 'Cook';
SELECT * FROM RoomSchedule;

DECLARE @num INT;
EXEC GuestRemove 1389, 1884, @num OUTPUT;
PRINT @num;
SELECT * FROM Guest;
SELECT * FROM Admin;

EXEC RecommendTD 1900, 'Dubai', 30, 1;
SELECT * FROM Recommendation;
SELECT * FROM Users;

EXEC Servailance 1101, 1425, 1;
SELECT * FROM Camera;

EXEC RoomAvailability 1300, 'Available';
SELECT * FROM Room;

EXEC Sp_Inventory 2231,'Todo',42131,'2023/12/2',1000,'Bakery','Desert';
EXEC Sp_Inventory @item_id = 7, @name = 'Potatoes', @quantity = 10, @expirydate = '2023-12-31',@price = 25.99, @manufacturer = 'Potato Farm',@category = 'Vegetables ';
SELECT * FROM Inventory;

DECLARE @total DECIMAL(10,2);
EXEC Shopping 1, 5, @total OUTPUT;
PRINT @total;

SELECT * FROM Inventory;

EXEC LogActivityDuration 1300, 1, 1900, '11/24/2023', '1 hour';
SELECT * FROM Log;

EXEC TabletConsumption @consumption = 50;
SELECT * FROM Consumption;

EXEC MakePreferencesRoomTemp @user_id = 1900 , @category = 'Bedroom' , @preferences_number= 30;
SELECT * FROM Preferences;

EXEC ViewMyLogEntry @user_id = 1900;
SELECT * FROM Log;

EXEC UpdateLogEntry @user_id = 1900, @room_id = 1300, @device_id = 1, @activity = 'Playing golf';
SELECT * FROM Log;

EXEC ViewRoom;

EXEC ViewMeeting @room_id =1599 ,@user_id = 1900;

EXEC AdminAddTask @user_id = 1909, @creator = 1900, @name = 'Clean BedRoom', @category = 'Hygeneic', @priority = 1, @status = 'Pending', @reminder = '2023/12/4', @deadline = '2023/3/3', @other_user = 1389;

DECLARE @user_id1 INT = 19291;
DECLARE @creator1 INT = 1900;
DECLARE @name1 VARCHAR(30) = 'Grocery shopping';
DECLARE @category1 VARCHAR(20) = 'Daily tasks';
DECLARE @priority1 INT = 1;
DECLARE @status1 VARCHAR(20) = 'Pending';
DECLARE @reminder1 DATETIME = '2023/1/01';
DECLARE @deadline1 DATETIME = '2023/1/15';
DECLARE @other_user1 INT = 1900;

EXEC AdminAddTask @user_id = @user_id1, @creator = @creator1, @name = @name1, @category = @category1, @priority = @priority1, @status = @status1, @reminder = @reminder1, @deadline = @deadline1, @other_user = @other_user1;

SELECT * FROM Tasks;
SELECT * FROM Assigned_to;
SELECT * FROM Room;

SELECT * FROM Guest;
SELECT * FROM Users;

EXEC AssignTask 1452 ,1,1900;
SELECT * FROM Assigned_to;
SELECT * FROM Tasks;

EXEC DeleteMsg;

EXEC AddItinerary @trip_no = 1000, @flight_num = 55 , @flight_date = '2023/2/2', @destination = 'Brazil';

EXEC ChangeFlight;
SELECT * FROM Travel;

EXEC UpdateFlight @date = '2023/2/3' , @destination = 'Cairo', @trip_no = 1000;

EXEC AddDevice @device_id = 9, @status = 'Out of battery',@battery = 0,@location = 1601, @type = 'Tablet';
EXEC AddDevice @device_id = 10, @status = 'Out of battery',@battery = 90,@location = 1601, @type = 'Tablet';
EXEC AddDevice @device_id = 19, @status = 'Charged',@battery = 90,@location = 1888, @type = 'Tablet';
EXEC AddDevice 12, 'Charged', 80, 1402, 'Laptop';
SELECT *  FROM Device;

EXEC OutOfBattery;
EXEC Charging;

EXEC GuestsAllowed @admin_id = 1909, @number_of_guests = 30;
EXEC GuestsAllowed 1900, 5;
SELECT no_of_guests_allowed from Admin where admin_id = 1101;
SELECT * FROM Admin;

DECLARE @penalty_amount INT = 300;
EXEC Penalize @penalty_amount;

DECLARE @admin_id INT = 1900;
DECLARE @guest_num INT;
EXEC GuestNumber @admin_id, @guest_num OUTPUT;
PRINT 'Number of Guests for Admin ' + CAST(@admin_id AS VARCHAR(10)) + ': ' + CAST(@guest_num AS VARCHAR(10));

EXEC Youngest;

DECLARE @amount DECIMAL(10, 2);
SET @amount = 7000.00;
EXEC AveragePayement @amount = 508;

DECLARE @sum INT;
EXEC Purchase @sum OUTPUT;
SELECT @sum AS TotalSumOfPurchases;

SELECT * FROM Device;
EXEC NeedCharge;

EXEC Admins;
