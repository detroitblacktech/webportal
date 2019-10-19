import os
import sys
from sqlalchemy import Column, ForeignKey, Integer, String, DateTime, Boolean
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
from sqlalchemy import create_engine, inspect
from sqlalchemy_utils import database_exists, create_database
from datetime import datetime
import settings


def row2dict(row):
    """ util function for converting sql row object to python dict """
    d = {}
    for column in row.__table__.columns:
        d[column.name] = str(getattr(row, column.name))
    return d


def object_as_dict(obj):
    """ util function for converting sql row object to python dict """
    return {c.key: getattr(obj, c.key)
            for c in inspect(obj).mapper.column_attrs}


Base = declarative_base()


class User(Base):
    __tablename__ = 'user'
    user_id = Column(Integer, primary_key=True)
    name = Column(String(250), nullable=False)
    email = Column(String(250), nullable=False)
    type = Column(String(50), nullable=False)


# +Add additional tables here+


def getDBURI():
    # Define the database URI
    if settings.DB_TYPE != "":
        sql_uri = settings.DB_TYPE + "://" + settings.DB_USER + ":" + settings.DB_PASS + "@" + settings.DB_HOST + "/" + settings.DB_NAME
        print(sql_uri)
        return sql_uri
    else:
        return None


# Make the engine global
try: 
    engine = create_engine(getDBURI(), echo=True, pool_recycle=10)

    # Create a database session
    Session = sessionmaker(bind=engine)

    if not database_exists(engine.url):

        # Create database
        create_database(engine.url)

        # Create all tables in the database engine
        Base.metadata.create_all(engine)

        # Add some sample data if in DEV mode
        if settings.ENV == "DEV":
            mack = User(name='Mack Hendricks', email='mack@detroitpbx.com', type='user')

            # Grab an instance of the Session object
            session = Session()

            # Add the sample users
            session.add(mack)

            # Commit these users to the database
            session.commit()
except:
    print("Database issue")

def loadSession():
    return Session()
