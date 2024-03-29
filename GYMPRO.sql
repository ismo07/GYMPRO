CREATE TABLE Users (
  UserID SERIAL PRIMARY KEY,
  Username VARCHAR(50) NOT NULL UNIQUE,
  Email VARCHAR(100) NOT NULL UNIQUE,
  Password VARCHAR(255) NOT NULL,  -- Remember to hash passwords before storing!
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  ExperienceLevel VARCHAR(25) CHECK (ExperienceLevel IN ('Beginner', 'Intermediate', 'Advanced')),  -- Optional check constraint
  Goals VARCHAR(255)
);

CREATE TABLE Categories (  -- Added for exercise categorization
  CategoryID SERIAL PRIMARY KEY,
  Name VARCHAR(50) NOT NULL
);

CREATE TABLE Exercises (
  ExerciseID SERIAL PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  Description TEXT,
  CategoryID INT NOT NULL,
  FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID),
  EquipmentNeeded VARCHAR(255),
  DifficultyLevel VARCHAR(25) CHECK (DifficultyLevel IN ('Beginner', 'Intermediate', 'Advanced')),  -- Changed ENUM to VARCHAR with check constraint (optional)
  Instructions TEXT,
  VideoURL VARCHAR(255),
  ImageURL VARCHAR(255)
);

CREATE TABLE Workouts (
  WorkoutID SERIAL PRIMARY KEY,
  UserID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  WorkoutName VARCHAR(100),
  Date DATE,
  Duration INT
);

ALTER TABLE Workouts  -- Add unique constraint to ensure unique workouts by date
  ADD CONSTRAINT unique_workout_date UNIQUE (Date);

CREATE TABLE Progress (  -- Tracks user performance for each exercise in a workout
  ProgressID SERIAL PRIMARY KEY,
  UserID INT NOT NULL,
  FOREIGN KEY (UserID) REFERENCES Users(UserID),
  ExerciseID INT NOT NULL,
  FOREIGN KEY (ExerciseID) REFERENCES Exercises(ExerciseID),
  WorkoutDate DATE NOT NULL,
  FOREIGN KEY (WorkoutDate) REFERENCES Workouts(Date),  -- References the unique Date column
  Sets INT,
  Reps INT,
  Weight DECIMAL
);

-- Insert Sample Data for Users
INSERT INTO Users (Username, Email, Password, FirstName, LastName, ExperienceLevel, Goals)
VALUES ('ismo', 'ismotol7@gmail.com', 'hashed_password', 'Ismail', 'Atolagbe', 'Beginner', 'Build Muscle'),
       ('sammyadex', 'sammyadexo4@gmail.com', 'hashed_password', 'Samuel', 'Adejuwon', 'Intermediate', 'Lose Weight'),
       ('mickey', 'mikhy@gmail.com', 'hashed_password', 'Timothy', 'Adejuwon', 'Advanced', 'Increase Strength'),
       ('Starboy', 'starrid@gmail.com', 'hashed_password', 'Ridwan', 'Adeleke', 'Beginner', 'Improve Flexibility'),
       ('yusuf', 'yusuf383893@gmail.com', 'hashed_password', 'Yusuf', 'Oladotun', 'Intermediate', 'Tone Up');

-- Insert Sample Data for Categories
INSERT INTO Categories (Name)
VALUES ('Chest'), ('Back'), ('Legs'), ('Core'), ('Cardio');

-- Insert Sample Data for Exercises (referencing CategoryIDs)
INSERT INTO Exercises (Name, Description, CategoryID, EquipmentNeeded, DifficultyLevel, Instructions)
VALUES ('Push-ups', 'Strengthens chest, shoulders, and triceps.', 1, 'Bodyweight', 'Beginner', 'Perform a full push-up from a high plank position, lowering your chest to the ground and then pushing back up to start.'),
       ('Pull-ups', 'Strengthens back and biceps.', 2, 'Pull-up bar', 'Intermediate', 'Grip the bar with an overhand grip and pull yourself up until your chin is above the bar. Lower yourself back down slowly.'),
       ('Squats', 'Strengthens legs and core.', 3, 'Bodyweight or barbell', 'Beginner', 'Stand with your feet shoulder-width apart and toes slightly outward. Squat down as if you are going to sit in a chair, keeping your back straight and core engaged. Push back up to starting position.'),
       ('Plank', 'Strengthens core and shoulders.', 4, 'Bodyweight', 'Beginner', 'Get into a high plank position with your forearms on the ground and your body in a straight line from head to heels. Hold for as long as you can with good form.'),
       ('Jumping Jacks', 'Cardiovascular exercise.', 5, 'No equipment', 'Beginner', 'Jump your feet out to the side while raising your arms overhead. Jump your feet back together and lower your arms to your sides. Repeat continuously.');

-- Insert Sample Data for Workouts (referencing UserIDs)
INSERT INTO Workouts (UserID, WorkoutName, Date, Duration)
VALUES (1, 'Chest Workout', '2024-03-10', 45),
       (2, 'Back and Bicep Workout', '2024-03-08', 45),
       (3, 'Leg Day', '2024-03-09', 30),
       (4, 'Core and Flexibility', '2024-03-07', 20),
       (5, 'Cardio Blast', '2024-03-06', 60);

-- Insert Sample Data for Progress (linking users, exercises, and workout performance)
INSERT INTO Progress (UserID, ExerciseID, WorkoutDate, Sets, Reps, Weight)
VALUES (1, 1, '2024-03-10', 3, 10, null),  -- Push-ups (Chest Workout)
       (1, 2, '2024-03-10', 2, 8, null),  -- Pull-ups (Chest Workout)
       (2, 2, '2024-03-08', 4, 12, null),  -- Pull-ups (Back and Bicep Workout)
       (3, 3, '2024-03-09', 3, 15, 20.0), -- Squats (Leg Day)
       (4, 4, '2024-03-07', 3, 60, null),  -- Plank (Core and Flexibility)
       (5, 5, '2024-03-06', 3, 20, null);  -- Jumping Jacks (Cardio Blast)

-- 1. Get all users with "Beginner" experience level
SELECT *
FROM Users
WHERE ExperienceLevel = 'Beginner';

-- 2. Get all workouts for a specific user ID (use your actual ID)
SELECT *
FROM Workouts
WHERE UserID = 1;  -- Replace 1 with your actual UserID

-- 3. Get all exercises categorized as "Cardio" (assuming a CategoryID for Cardio)
SELECT e.Name, c.Name AS Category
FROM Exercises e
INNER JOIN Categories c ON e.CategoryID = c.CategoryID
WHERE c.Name = 'Cardio';

-- 4. Get the total number of workouts for each user
SELECT u.Username, COUNT(w.WorkoutID) AS TotalWorkouts
FROM Workouts w
INNER JOIN Users u ON w.UserID = u.UserID
GROUP BY u.Username;


-- 5. Find exercises that don't require any equipment (use NULL check)
SELECT Name
FROM Exercises
WHERE EquipmentNeeded IS NULL;

-- 6. Get the average weight lifted (aggregate function AVG) for all exercises in a specific user's workouts (use your UserID)
SELECT AVG(Weight) AS AvgWeightLifted
FROM Progress p
WHERE UserID = 1; 

-- 7. Get all workouts with a duration exceeding 45 minutes (use HAVING with aggregate function)

-- 8. Get all exercises completed by a user on a specific date (use your UserID and date)
SELECT e.Name, w.WorkoutName
FROM Progress p
INNER JOIN Workouts w ON p.WorkoutDate = w.Date
INNER JOIN Exercises e ON p.ExerciseID = e.ExerciseID
WHERE p.UserID = 1 AND p.WorkoutDate = '2024-03-10';  -- Replace UserID and date with your information

-- 9. Get details of all users and their most recent workouts (LEFT JOIN)
SELECT u.Username, w.WorkoutName, w.Date
FROM Users u
LEFT JOIN (
  SELECT UserID, MAX(Date) AS MaxWorkoutDate
  FROM Workouts
  GROUP BY UserID
) AS latest_workouts ON u.UserID = latest_workouts.UserID
LEFT JOIN Workouts w ON latest_workouts.UserID = w.UserID AND latest_workouts.MaxWorkoutDate = w.Date;

-- 10. Get details of exercises performed by a user along with their difficulty level (INNER JOIN)
SELECT e.Name, c.Name AS Difficulty
FROM Progress p
INNER JOIN Exercises e ON p.ExerciseID = e.ExerciseID
INNER JOIN Categories c ON e.DifficultyLevel = c.Name  -- Assuming DifficultyLevel stores category name
WHERE p.UserID = 1;  
