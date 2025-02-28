import mysql.connector
from config import Config

def create_database():
    # Connect without database selected
    db = mysql.connector.connect(
        host=Config.MYSQL_HOST,
        user=Config.MYSQL_USER,
        password=Config.MYSQL_PASSWORD,
        port=Config.MYSQL_PORT
    )
    
    cursor = db.cursor()
    
    # Create database if it doesn't exist
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {Config.MYSQL_DB}")
    cursor.execute(f"USE {Config.MYSQL_DB}")
    
    # Read and execute SQL file
    with open('faculty_timetable_updated.sql', 'r') as file:
        sql_commands = file.read()
        
    # Execute each command separately
    for command in sql_commands.split(';'):
        if command.strip():
            try:
                cursor.execute(command)
                db.commit()
            except mysql.connector.Error as err:
                print(f"Error executing command: {err}")
                db.rollback()
    
    # Add sample substitutions
    try:
        cursor.execute('''
            INSERT INTO substitutions 
            (class_id, original_staff_id, substitute_staff_id, start_date, end_date, reason) 
            VALUES 
            ((SELECT id FROM classes WHERE name = 'CSE-A Programming'),
             (SELECT id FROM staff WHERE name = 'John Doe'),
             (SELECT id FROM staff WHERE name = 'Jane Smith'),
             '2024-03-20', '2024-03-22',
             'Medical Leave'),
            ((SELECT id FROM classes WHERE name = 'CSE-A Digital Electronics'),
             (SELECT id FROM staff WHERE name = 'Jane Smith'),
             (SELECT id FROM staff WHERE name = 'Robert Johnson'),
             '2024-03-25', '2024-03-26',
             'Conference Attendance')
        ''')
        db.commit()
    except mysql.connector.Error as err:
        print(f"Error adding sample substitutions: {err}")
        db.rollback()
    
    cursor.close()
    db.close()

if __name__ == "__main__":
    create_database()
    print("Database setup completed!") 