import requests
from creds import token
import time
from pyswip import Prolog
"""
"https://api.lufthansa.com/v1/flight-schedules/flightschedules/passenger?airlines=LH&startDate=25OCT21&endDate=25OCT21&daysOfOperation=1234567&timeMode=UTC" -H  "accept: application/json" -H  "Authorization: Bearer r467s5wz9r5525n8bp5ap99d"
"""
airlines = "LH"
startDate = "25OCT21"
endDate = "25OCT21"
#r = requests.get(f'https://api.lufthansa.com/v1/flight-schedules/flightschedules/passanger?airlines={airlines}&startDate={startDate}&endDate={endDate}&daysOfOperation=1234567&timeMode=UTC')
payload = {'directFlights': 0}
headers = {"Authorization": 'Bearer ' + token, "Accept": "application/json", "X-Originating-IP": "80.235.76.174"}
date = "2021-10-26"

def get_query(schedule):
    try:
        flights = schedule["Flight"]
    except TypeError:
        return -1
    querys = []
    if isinstance(flights,list):
        for flight in flights:
            cost = flight["MarketingCarrier"]["FlightNumber"]
            departure = get_flight_data(flight["Departure"])

            arrival = get_flight_data(flight["Arrival"])
            query = f"lennukiga{departure[0], arrival[0], cost, departure[1], arrival[1]}."
            querys.append(query)
    else:
        cost = flights["MarketingCarrier"]["FlightNumber"]
        departure = get_flight_data(flights["Departure"])
        arrival = get_flight_data(flights["Arrival"])
        query = f"lennukiga{departure[0], arrival[0], cost, departure[1], arrival[1]}."
        querys.append(query)
    return querys

def get_flight_data(data):
    x = data["AirportCode"].lower()
    time = data["ScheduledTimeLocal"]["DateTime"].split("T")[1]
    time = f"time({time.split(':')[0]},{time.split(':')[1]},0.0)"
    return x, time

def get_data():
    codes = ["TLL", "CPH", "FRA", "HEL", "MAN", "MUC"]
    data = []
    for c1 in codes:
        for c2 in codes:
            if c1 == c2:
                continue
            print(len(data))
            r = requests.get(f"https://api.lufthansa.com/v1/operations/schedules/{c1}/{c2}/{date}", headers=headers, params=payload)
            print(f"https://api.lufthansa.com/v1/operations/schedules/{c1}/{c2}/{date}")
            if r.status_code != 200:
                continue
            schedules = r.json()["ScheduleResource"]["Schedule"]
            for schedule in schedules:
                querys = get_query(schedule)
                if querys != -1:
                    data.extend(querys)
    return data

def load_data_to_file(data, file):
    with open(file, "a") as f:
        for query in data:
            print(query.replace("'", ""))
            f.write(query.replace("'", ""))
            f.write("\n")

def load_data_from_file(file):
    with open(file) as f:
        lines = f.read().splitlines()
    return list([line[:-1] for line in lines])

def do_query():
    data = load_data_from_file("data.pl")
    prolog = Prolog()
    prolog.consult("prax06.pl")
    for query in data:
        prolog.asserta(query)
    for sol in prolog.query("reisi(tll, Y)"):
        print(sol)
    return load_data_from_file("data.pl")




if __name__ == "__main__":
    #data = get_data()
    #load_data_to_file(data, "data.pl")
    do_query()
    
