Which country has the highest total deal value?
SELECT *
FROM dbo.CRM_and_Sales_Pipelines
WHERE Deal_Value IS NULL
--What is the average deal value for each industry?--

SELECT Organization, 
AVG(Deal_Value) AS Avg_Deal_Value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Organization

--Which product has the highest average probability of closing?

SELECT Product,
AVG(Probability) AS avg_Probability
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Product

---What is the total number of deals for each status?

SELECT Status,
SUM(Deal_value) AS Total_Deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Status

--Which owner has the highest total deal value?

SELECT TOP 1 Owner,
SUM(Deal_value) AS Total_Deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Owner

--What is the average deal value for each owner?
SELECT Owner,
AVG(Deal_value) AS Avg_Deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Owner

--How many deals have a probability greater than 70%?

WITH high_probability_deals AS (
    SELECT *
    FROM dbo.CRM_and_Sales_Pipelines
    WHERE Probability > 70
)
SELECT COUNT(*) AS deal_count
FROM high_probability_deals;

---What is the distribution of deal values across different stages?

SELECT Stage, COUNT (Deal_value) AS deal_value
FROM dbo.CRM_and_Sales_Pipelines
WHERE Stage  IS NOT NULL
GROUP BY Stage

--What is the average lead acquisition time for deals in each industry?

WITH Lead_Times AS (
    SELECT 
        industry,
        DATEDIFF(HOUR, Lead_acquisition_date, Actual_close_date) AS lead_time_hours
    FROM dbo.CRM_and_Sales_Pipelines
)
SELECT 
    industry, 
    AVG(lead_time_hours) AS avg_lead_acquisition_time
FROM Lead_Times
GROUP BY industry;


---How many deals were closed in each month of 2024?

SELECT 
DATENAME(MONTH,Actual_close_date) AS Month_name,
COUNT(Deal_value) AS Deal_value
FROM dbo.CRM_and_Sales_Pipelines
WHERE YEAR(Actual_close_date) = 2024
GROUP BY DATENAME(MONTH, Actual_close_date),
         MONTH(Actual_close_date)
ORDER BY MONTH(Actual_close_date)
---What is the average deal value for deals acquired in each quarter of 2024?
WITH quarter_deals AS(
SELECT 
'Q' + CAST(DATEPART(QUARTER, Lead_acquisition_date) AS VARCHAR) AS quarter_deal,
AVG(Deal_value) AS avg_Deal_value
FROM dbo.CRM_and_Sales_Pipelines
WHERE YEAR(Lead_acquisition_date) = 2024
GROUP BY DATEPART(QUARTER, Lead_acquisition_date)
) 
SELECT 
quarter_deal, 
avg_Deal_value
FROM quarter_deals
ORDER BY quarter_deal

Which industries have the highest and lowest average deal values?

WITH avg_deal_values AS (
    SELECT 
        Industry,
        AVG(Deal_value) AS avg_deal_value,
        ROW_NUMBER() OVER (ORDER BY AVG(Deal_value) DESC) AS highest_rank,
        ROW_NUMBER() OVER (ORDER BY AVG(Deal_value) ASC) AS lowest_rank
    FROM 
        dbo.CRM_and_Sales_Pipelines
    GROUP BY 
        Industry
)
SELECT 
    CASE WHEN highest_rank = 1 THEN 'Highest' ELSE 'Lowest' END AS Type,
    Industry,
    avg_deal_value
FROM 
    avg_deal_values
WHERE 
    highest_rank = 1 OR lowest_rank = 1;

What is the correlation between deal value and probability of closing?
--What is the average deal value for each organization size?
SELECT Organization_size,
AVG(Deal_value) AS avg_deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Organization_size

Which country has the highest average deal value?

SELECT TOP 1 Country,
AVG(Deal_Value) AS avg_deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Country
ORDER BY avg_deal_value DESC

How many deals were closed on time versus late for each owner?

What is the average deal value for each status sequence?

SELECT status_sequence,
AVG(Deal_value) AS avg_deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY status_sequence

What is the average probability of closing for each stage?
SELECT stage,
AVG(probability) AS avg_probability
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY stage
How many deals have a deal value greater than $1,000?
SELECT deal_value
FROM dbo.CRM_and_Sales_Pipelines
WHERE deal_value > 1000

Which owner has the highest average probability of closing?

SELECT 
    Owner,
    AVG(Probability) AS avg_probability_of_closing
FROM 
    dbo.CRM_and_Sales_Pipelines
GROUP BY 
    Owner
ORDER BY 
    avg_probability_of_closing DESC;

What is the total deal value for each product in each country?
SELECT Country,
SUM(Deal_value) AS total_deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Country
How many deals were closed in each stage sequence?
SELECT Stage_sequence,
COUNT(Deal_value)AS Deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Stage_sequence


What is the average probability of closing for each organization size?
SELECT Organization_size,
AVG(probability) AS avg_probability
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Organization_size

Which industries have the highest total deal values?
SELECT Organization,
SUM(Deal_value) AS total_deal_value
FROM dbo.CRM_and_Sales_Pipelines
GROUP BY Organization
ORDER BY total_deal_value DESC;
What is the average expected close time for deals in each industry?

SELECT Industry,
AVG(DATEDIFF(DAY,Expected_close_date,Actual_close_date))AS Avg_closing_time
FROM dbo.CRM_and_Sales_Pipelines
WHERE Expected_close_date IS NOT NULL 
AND Actual_close_date IS NOT NULL
GROUP BY Industry;