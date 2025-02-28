import os
from dotenv import load_dotenv
import secrets

load_dotenv()

class Config:
    SECRET_KEY = os.getenv('SECRET_KEY', secrets.token_hex(32))
    MYSQL_HOST = os.getenv('MYSQL_HOST', 'localhost')
    MYSQL_USER = os.getenv('MYSQL_USER', 'root')
    MYSQL_PASSWORD = os.getenv('MYSQL_PASSWORD', '12345')
    MYSQL_PORT = int(os.getenv('MYSQL_PORT', '3308'))
    MYSQL_DB = os.getenv('MYSQL_DB', 'faculty_timetable3') 