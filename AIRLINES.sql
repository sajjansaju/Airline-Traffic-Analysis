CREATE TABLE airlines (
    Month TEXT,
    In_Out CHAR(1),
    Australian_City VARCHAR(100),
    International_City VARCHAR(100),
    Airline VARCHAR(100),
    Route TEXT,
    Port_Country VARCHAR(100),
    Port_Region VARCHAR(50),
    Service_Country VARCHAR(100),
    Service_Region VARCHAR(50),
    Stops INTEGER,
    All_Flights INTEGER,
    Max_Seats INTEGER,
    Year INTEGER,
    Month_num INTEGER
);

--Identify peak travel months by no of flights alloted.
select month_num as months,
sum(all_flights) as total_flights
from airlines
group by months
order by total_flights desc;


--Identify peak travel year by no of flights alloted.
select year,
sum(all_flights) as total_flights
from airlines
group by year
order by total_flights desc;

--Find airlines with the highest flights and seat capacity.
select airline,
sum(all_flights) as total_flights,
sum(max_seats) as total_seats
from airlines
group by airline
order by total_flights desc, total_seats desc;

--Analyze the top airline performance trends over time.
select year,
sum(all_flights) as total_flight,
sum(sum(all_flights)) over (order by year) as running_total
from airlines
where airline = 'Qantas Airways'
group by year;

-- Identify top-performing international routes by flight volume.
select route as flight_route,
sum(all_flights) as Total_flights
from airlines
group by flight_route
order by Total_flights desc
limit 3;

--Find least-served routes.
select route as flight_route,
sum(all_flights) as Total_flights
from airlines
group by flight_route
order by Total_flights asc
limit 3;

--Analyze the number of direct flights on each route.
select route as flight_route,
sum(all_flights) as Total_direct_flights
from airlines
where stops = 0
group by flight_route
order by Total_direct_flights desc;

--Identify cities with a major outbound.
select australian_city as city,
sum(all_flights) as total_flights
from airlines
where in_out ='O'
group by city
order by total_flights desc;

--Identify cities with a major inbound.
select australian_city as city,
sum(all_flights) as total_flights
from airlines
where in_out ='I'
group by city
order by total_flights desc;

--Visualize direction-based trends.
select year,
sum(case when in_out = 'I' then all_flights else 0 end) as inbound_flights,
sum(case when in_out = 'O' then all_flights else 0 end) as outbound_flights
from airlines
group by year
order by year asc;

--Rank regions based on total flights and seat count
select port_region,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat
from airlines
group by port_region
order by total_flights desc,total_seat desc;

--Rank regions and countries based on total flights and seat count.
select port_country,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat
from airlines
group by port_country
order by total_flights desc,total_seat desc;

--Track growth in travel from Southeast Asia, Northeast Asia, etc.

select year,
SUM(case when port_region = 'SE Asia'then all_flights else 0 end) as inbond_flights_frm_Southeast_Asia,
SUM(case when port_region = 'NE Asia'then all_flights else 0 end) as inbond_flights_frm_Northeast_Asia
from airlines
where in_out = 'I'
group by year
order by year;

--or( the above one is pvioted version to we can add more region to it using case statement )
 
select year,
port_region,
sum(all_flights)as total_flights
from airlines
where in_out ='I'
group by year, port_region
order by year asc, total_flights desc;


--Analyze flight capacity and counts based on number of stops.
select stops,
count(distinct route) as total_distinct_routes,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat_capacity,
ceil(avg(max_seats))as avg_seat_capacity
from airlines
group by stops
order by stops asc;

--Compare direct vs. connecting routes in terms of performance.
select 
case when stops = 0 then 'direct flight'
else 'connecting flight'
end as route_type,
count(distinct route) as total_distinct_routes,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat_capacity,
ceil(avg(max_seats))as avg_seat_capacity
from airlines
group by route_type;

--Find cities with the most international connections.
select australian_city,
count(distinct international_city) as total_international_connections
from airlines
group by australian_city
order by total_international_connections desc;

--Track yearly growth of outbound flights for each city.
select year,
sum(case when australian_city= 'Sydney' then all_flights else 0 end )as Sydney,
sum(case when australian_city= 'Melbourne' then all_flights else 0 end )as Melbourne,
sum(case when australian_city= 'Brisbane' then all_flights else 0 end )as Brisbane,
sum(case when australian_city= 'Perth' then all_flights else 0 end )as Perth,
sum(case when australian_city= 'Cairns' then all_flights else 0 end )as Cairns,
sum(case when australian_city= 'Darwin' then all_flights else 0 end )as Darwin,
sum(case when australian_city= 'Adelaide' then all_flights else 0 end )as Adelaide,
sum(case when australian_city= 'Gold Coast' then all_flights else 0 end )as Gold_Coast,
sum(case when australian_city= 'Canberra' then all_flights else 0 end )as Canberra
from airlines
where in_out ='O'
group by year
order by year asc;


--Rank cities by route diversity.
select australian_city,
count(distinct route) as route_diversity
from airlines
group by australian_city
order by route_diversity desc, australian_city asc;

