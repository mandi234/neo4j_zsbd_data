CREATE CONSTRAINT ON (c:Crime) ASSERT c.crime_id IS UNIQUE;

:auto USING PERIODIC COMMIT 1000
LOAD CSV WITH HEADERS FROM "file:///crime.csv" AS row
WITH row WHERE row.id IS  NOT NULL
MERGE (c:Crime {crime_id: row.id})
ON CREATE SET c.offence_desc = row.highest_offense_description,
              c.family_violence = CASE WHEN row.family_violence="N" THEN true ELSE false END,
              c.occured_date = row.occured_date,
              c.occured_time = row.occured_time,
              c.location_type = row.location_type,
              c.address = row.address,
              c.latitude = toFloat(row.latitude),
              c.longitude = toFloat(row.longitude)
ON MATCH SET c.count = coalesce(c.count, 0) + 1