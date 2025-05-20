-- ========================================
-- Clinic Booking Management System (Schema + Sample Data)
-- ========================================

-- DROP TABLES (For resetting purposes during development)
DROP TABLE IF EXISTS Billing, Appointment_Treatments, Appointments, Treatments, Patients, Doctors;

-- ========================
-- Table: Doctors
-- ========================
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);

-- Sample Doctors
INSERT INTO Doctors (FullName, Specialization, Email, Phone) VALUES
('Dr. Sarah Lee', 'Cardiologist', 'sarah.lee@clinic.com', '1234567890'),
('Dr. James Smith', 'Dermatologist', 'james.smith@clinic.com', '2345678901');

-- ========================
-- Table: Patients
-- ========================
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address TEXT
);

-- Sample Patients
INSERT INTO Patients (FullName, DateOfBirth, Gender, Email, Phone, Address) VALUES
('Alice Johnson', '1990-06-15', 'Female', 'alice.johnson@email.com', '5551234567', '123 Main St'),
('Bob White', '1985-09-30', 'Male', 'bob.white@email.com', '5552345678', '456 Oak Ave');

-- ========================
-- Table: Appointments
-- ========================
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME NOT NULL,
    Reason TEXT,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Sample Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason, Status) VALUES
(1, 1, '2025-05-21 10:00:00', 'Routine Checkup', 'Scheduled'),
(2, 2, '2025-05-22 14:30:00', 'Skin Rash', 'Scheduled');

-- ========================
-- Table: Treatments
-- ========================
CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    TreatmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    Cost DECIMAL(10, 2) NOT NULL
);

-- Sample Treatments
INSERT INTO Treatments (TreatmentName, Description, Cost) VALUES
('ECG', 'Electrocardiogram test', 150.00),
('Skin Biopsy', 'Sample skin tissue analysis', 200.00);

-- ========================
-- Table: Appointment_Treatments (M-M between Appointments and Treatments)
-- ========================
CREATE TABLE Appointment_Treatments (
    AppointmentID INT,
    TreatmentID INT,
    PRIMARY KEY (AppointmentID, TreatmentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID)
);

-- Sample Links
INSERT INTO Appointment_Treatments (AppointmentID, TreatmentID) VALUES
(1, 1),
(2, 2);

-- ========================
-- Table: Billing
-- ========================
CREATE TABLE Billing (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT UNIQUE,
    TotalAmount DECIMAL(10, 2),
    PaymentStatus ENUM('Pending', 'Paid') DEFAULT 'Pending',
    PaymentDate DATE,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Sample Billing Records
INSERT INTO Billing (AppointmentID, TotalAmount, PaymentStatus, PaymentDate) VALUES
(1, 150.00, 'Paid', '2025-05-21'),
(2, 200.00, 'Pending', NULL);
