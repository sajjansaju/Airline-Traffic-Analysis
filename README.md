# ✈️ International Airlines SQL Analysis 


## 🧩 Problem Statement

As a Data Analyst working with a national aviation board, your mission is to analyze international air traffic trends between Australian cities and global destinations using historical flight data (2003–2020). The goal is to extract actionable insights that can help stakeholders understand international route performance, airline seat capacity, city-level contributions, and travel patterns across time, stops, and regions.

The dataset used for this project is publicly available on Kaggle:  
**[Australian Flight Dataset (2003–2022) – by Gaurav Pandey](https://www.kaggle.com/datasets/pandeyg0811/australian-flight-dataset-2003-2022)**


## 🎯 Project Objectives

**1.Explore Time-Based Trends**
- Identify peak travel months and years.

**2.Rank Top Airlines by Traffic and Capacity**
- Find airlines with the highest flights and seat capacity.
- Analyze the top airline performance trends over time.

**3.Understand Route-Level Performance**
- Identify top-performing international routes by flight volume.
- Find least-served routes.
- Analyze the number of direct flights on each route.

**4.Compare Inbound vs Outbound Patterns**
- Identify cities with a major outbound or inbound bias.
- Visualize direction-based trends.

**5.Regional and Country-Level Analysis**
- Rank regions and countries based on total flights and seat count.
- Track growth in travel from Southeast Asia, Northeast Asia, etc.

**6.Flight Stop Analysis**
- Analyze flight capacity and counts based on number of stops.
- Compare direct vs. connecting routes in terms of performance.

**7.Australian City-Level Insights**
- Find cities with the most international connections.
- Track yearly growth of outbound flights for each city.
- Rank cities by route diversity.


## 📌 Findings & Conclusion

After conducting a detailed analysis of international air traffic patterns across Australian cities using two decades of flight data. This project uncovered valuable insights to inform aviation strategy, resource allocation, and market development.

### 🔍 Key Findings

- **Peak Travel Periods**: December consistently recorded the highest international flight volumes, suggesting that holiday seasons drive peak demand. The years **2018 and 2019** marked the industry's operational peak before the **COVID-19** disruption.

- **Airline & Route Dominance**: **Qantas Airways** led both in flight frequency and seat capacity, while **Sydney-Auckland** was the most active international route, reflecting strong travel ties with **New Zealand and Southeast Asia**.

- **Inbound vs. Outbound Balance**: Australian cities displayed **balanced inbound and outbound volumes** over time, affirming Australia's stable role in global travel corridors.

- **Regional & Country Trends**: **Southeast Asia** emerged as the top contributing region for flights, followed by **New Zealand** and **Northeast Asia**. Countries like **Singapore**, **Indonesia**, and the **USA** are key international partners.

- **Efficiency & Preferences**: **Direct flights** significantly outperformed connecting routes in both usage and efficiency, emphasizing travelers' preference for faster, non-stop travel options.

- **City-Level Insights**: **Sydney**, **Melbourne**, and **Brisbane** are Australia’s global aviation hubs, offering the most connections and highest route diversity. In contrast, smaller cities had limited international reach but showed occasional spikes.

### 🧠 Conclusion

This analysis not only highlighted key performance areas of Australia's international aviation landscape but also demonstrated how **structured SQL analysis** can translate raw data into **actionable business insights**. These insights support strategic decisions in **airline route planning**, **airport resource management**, and **international partnership development**. As travel continues to rebound post-pandemic, **data-driven forecasting and planning** will be crucial to ensuring sustainable growth in the sector.


---
## 🔎 SQL Query 

**1)Identify peak travel months by no of flights alloted.**
```sql
select month_num as months,
sum(all_flights) as total_flights
from airlines
group by months
order by total_flights desc;
```

**2)Identify peak travel year by no of flights alloted.**
```sql
select year,
sum(all_flights) as total_flights
from airlines
group by year
order by total_flights desc;
```

**3)Find airlines with the highest flights and seat capacity.**
```sql
select airline,
sum(all_flights) as total_flights,
sum(max_seats) as total_seats
from airlines
group by airline
order by total_flights desc, total_seats desc;
```

**4)Analyze the top airline performance trends over time.**
```sql
select year,
sum(all_flights) as total_flight,
sum(sum(all_flights)) over (order by year) as running_total
from airlines
where airline = 'Qantas Airways'
group by year;
```

**5)Identify top-performing international routes by flight volume.**
```sql
select route as flight_route,
sum(all_flights) as Total_flights
from airlines
group by flight_route
order by Total_flights desc
limit 3;
```

**6)Find least-served routes.**
```sql
select route as flight_route,
sum(all_flights) as Total_flights
from airlines
group by flight_route
order by Total_flights asc
limit 3;
```

**7)Analyze the number of direct flights on each route.**
```sql
select route as flight_route,
sum(all_flights) as Total_direct_flights
from airlines
where stops = 0
group by flight_route
order by Total_direct_flights desc;
```

**8)Identify cities with a major outbound.**
```sql
select australian_city as city,
sum(all_flights) as total_flights
from airlines
where in_out ='O'
group by city
order by total_flights desc;
```

**9)Identify cities with a major inbound.**
```sql
select australian_city as city,
sum(all_flights) as total_flights
from airlines
where in_out ='I'
group by city
order by total_flights desc;
```

**10)Visualize direction-based trends.**
```sql
select year,
sum(case when in_out = 'I' then all_flights else 0 end) as inbound_flights,
sum(case when in_out = 'O' then all_flights else 0 end) as outbound_flights
from airlines
group by year
order by year asc;
```

**11)Rank regions based on total flights and seat count.**
```sql
select port_region,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat
from airlines
group by port_region
order by total_flights desc,total_seat desc;
```

**12)Rank countries based on total flights and seat count.**
```sql
select port_country,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat
from airlines
group by port_country
order by total_flights desc,total_seat desc;
```

**13)Track growth in travel from Southeast Asia, Northeast Asia, etc.**
```sql
select year,
SUM(case when port_region = 'SE Asia'then all_flights else 0 end) as inbond_flights_frm_Southeast_Asia,
SUM(case when port_region = 'NE Asia'then all_flights else 0 end) as inbond_flights_frm_Northeast_Asia
from airlines
where in_out = 'I'
group by year
order by year;
```

**14)Analyze flight capacity and counts based on number of stops.**
```sql
select stops,
count(distinct route) as total_distinct_routes,
sum(all_flights) as total_flights,
sum(max_seats)as total_seat_capacity,
ceil(avg(max_seats))as avg_seat_capacity
from airlines
group by stops
order by stops asc;
```

**15)Compare direct vs. connecting routes in terms of performance.**
```sql
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
```

**16)Find cities with the most international connections.**
```sql
select australian_city,
count(distinct international_city) as total_international_connections
from airlines
group by australian_city
order by total_international_connections desc;
```

**17)Track yearly growth of outbound flights for each city.**
```sql
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
```

**18)Rank cities by route diversity.**
```sql
select australian_city,
count(distinct route) as route_diversity
from airlines
group by australian_city
order by route_diversity desc, australian_city asc;
```

---

## 🛠️ Tools Used
- **PostgreSQL** for SQL querying
- **Markdown / GitHub** for documentation and version control

## 🛡️ License

This project is licensed under the CC BY-NC-ND 4.0 License.  
Unauthorized reposting or modification is strictly prohibited.  
[View License](http://creativecommons.org/licenses/by-nc-nd/4.0/)
📩 For access or collaboration requests, please email me at: navakumarsajjan@gmail.com




























