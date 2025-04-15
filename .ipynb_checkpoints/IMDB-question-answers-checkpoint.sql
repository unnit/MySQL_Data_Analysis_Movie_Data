USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT COUNT(*) AS director_mapping_count FROM director_mapping;
SELECT COUNT(*) AS genre_count FROM genre;
SELECT COUNT(*) AS movie_count FROM movie;
SELECT COUNT(*) AS names_count FROM names;
SELECT COUNT(*) AS ratings_count FROM ratings;
SELECT COUNT(*) AS role_mapping_count FROM role_mapping;

-- To find the count of all the rows in a single query
SELECT
    table_name,
    table_rows
FROM
    information_schema.tables
WHERE
    table_schema = 'imdb';

/*
+------------------+------------+
| table_name       | table_rows |
+------------------+------------+
| director_mapping |       3867 |
| genre            |      14662 |
| movie            |       7125 |
| names            |      29547 |
| ratings          |       8230 |
| role_mapping     |      15168 |
+------------------+------------+
 */


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT COUNT(*) AS id_null_count FROM movie WHERE id is NULL;
SELECT COUNT(*) AS title_null_count FROM movie WHERE title is NULL;
SELECT COUNT(*) AS year_null_count FROM movie WHERE year is NULL;
SELECT COUNT(*) AS date_published_null_count FROM movie WHERE date_published is NULL;
SELECT COUNT(*) AS duration_null_count FROM movie WHERE duration is NULL;
SELECT COUNT(*) AS country_null_count FROM movie WHERE country is NULL;
SELECT COUNT(*) AS worlwide_gross_income_null_count FROM movie WHERE worlwide_gross_income is NULL;
SELECT COUNT(*) AS languages_null_count FROM movie WHERE languages is NULL;
SELECT COUNT(*) AS production_company_null_count FROM movie WHERE production_company is NULL;

/*
+--------------------+
| country_null_count |
+--------------------+
|                 20 |
+--------------------+

+----------------------------------+
| worlwide_gross_income_null_count |
+----------------------------------+
|                             3724 |
+----------------------------------+

+----------------------+
| languages_null_count |
+----------------------+
|                  194 |
+----------------------+

+-------------------------------+
| production_company_null_count |
+-------------------------------+
|                           528 |
+-------------------------------+
*/

-- The following columns of movie table are having null values
-- country
-- worlwide_gross_income
-- languages
-- production_company

-- The other option is to have a CASE statement to find NULL
SELECT
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS id_nulls,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS date_published_nulls,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_nulls,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_nulls,
    COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS worlwide_gross_income_nulls,
    COUNT(CASE WHEN languages IS NULL THEN 1 END) AS languages_nulls,
    COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS production_company_nulls
FROM
    movie;

/*
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+
| id_nulls | title_nulls | year_nulls | date_published_nulls | duration_nulls | country_nulls | worlwide_gross_income_nulls | languages_nulls | production_company_nulls |
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+
|        0 |           0 |          0 |                    0 |              0 |            20 |                        3724 |             194 |                      528 |
+----------+-------------+------------+----------------------+----------------+---------------+-----------------------------+-----------------+--------------------------+

Columns with NULL values
country
worlwide_gross_income
languages
production_company
*/

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Count of Movies for each year
SELECT
	year, COUNT(*) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

/*
+------+------------------+
| year | number_of_movies |
+------+------------------+
| 2017 |             3052 |
| 2018 |             2944 |
| 2019 |             2001 |
+------+------------------+
*/
-- The trend that we see here is that the number of movies releases are decreasing.

-- Count of movies for each month
SELECT
	month(date_published) AS month_num,
	COUNT(*) AS number_of_movies
FROM
	movie
GROUP BY month_num
ORDER BY month_num;

/*
+-----------+------------------+
| month_num | number_of_movies |
+-----------+------------------+
|         1 |              804 |
|         2 |              640 |
|         3 |              824 |
|         4 |              680 |
|         5 |              625 |
|         6 |              580 |
|         7 |              493 |
|         8 |              678 |
|         9 |              809 |
|        10 |              801 |
|        11 |              625 |
|        12 |              438 |
+-----------+------------------+
*/

-- The highest number of movies are released in the month of March followed by September and January.

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT
	country,
	COUNT(*) AS number_of_movies_2019
FROM
	movie
WHERE 
	country in ('India', 'USA')
    AND year=2019
GROUP BY country;

/*
+---------+-----------------------+
| country | number_of_movies_2019 |
+---------+-----------------------+
| India   |                   295 |
| USA     |                   592 |
+---------+-----------------------+
*/

/*
A total of 887 movies were produced by India and USA in the year 2019
But we have country values that are having more than one country, So we can make change to our query as below.
*/

SELECT
	country,
	COUNT(*) AS number_of_movies_2019
FROM
	movie
WHERE 
	(country REGEXP '(^|,\\s*)USA($|,\\s*)' OR country REGEXP '(^|,\\s*)India($|,\\s*)')
    AND year=2019
GROUP BY country;

/*
+---------------------------------------------------------------------------------------+-----------------------+
| country                                                                               | number_of_movies_2019 |
+---------------------------------------------------------------------------------------+-----------------------+
| India                                                                                 |                   295 |
| USA                                                                                   |                   592 |
| USA, Canada                                                                           |                     9 |
| USA, UK                                                                               |                     7 |
| South Korea, USA                                                                      |                     1 |
| USA, China                                                                            |                     3 |
| India, Pakistan, UK                                                                   |                     1 |
| USA, Spain, Bulgaria                                                                  |                     1 |
| Canada, USA                                                                           |                    12 |
| UK, USA                                                                               |                    28 |
...
...
| Indonesia, USA                                                                        |                     1 |
| India, USA                                                                            |                     1 |
| USA, India, South Korea, China                                                        |                     1 |
+---------------------------------------------------------------------------------------+-----------------------+
*/

WITH movie_count_ind_usa AS
(
	SELECT
		country,
		COUNT(*) AS number_of_movies_2019
	FROM
		movie
	WHERE 
		(country REGEXP '(^|,\\s*)USA($|,\\s*)' OR country REGEXP '(^|,\\s*)India($|,\\s*)')
		AND year=2019
	GROUP BY country
)
SELECT SUM(number_of_movies_2019) AS total_movies FROM movie_count_ind_usa;

/*
+--------------+
| total_movies |
+--------------+
|         1059 |
+--------------+
*/

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:


SELECT 
	genre
FROM
	GENRE
GROUP BY
	genre;

/*
+-----------+
| genre     |
+-----------+
| Action    |
| Adventure |
| Comedy    |
| Crime     |
| Drama     |
| Family    |
| Fantasy   |
| Horror    |
| Mystery   |
| Others    |
| Romance   |
| Sci-Fi    |
| Thriller  |
+-----------+
*/

-- We can also use SELECT DISTINCT genre from genre; also to get the unique count but chose GROUP BY as it gets preformed first.


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT
	genre,
	count(*) as genre_count
FROM
	genre AS g
INNER JOIN
	movie AS m
	ON g.movie_id = m.id
GROUP BY
	genre
ORDER BY genre_count DESC;

/*
+-----------+-------------+
| genre     | genre_count |
+-----------+-------------+
| Drama     |        4285 |
| Comedy    |        2412 |
| Thriller  |        1484 |
| Action    |        1289 |
| Horror    |        1208 |
| Romance   |         906 |
| Crime     |         813 |
| Adventure |         591 |
| Mystery   |         555 |
| Sci-Fi    |         375 |
| Fantasy   |         342 |
| Family    |         302 |
| Others    |         100 |
+-----------+-------------+
*/

SELECT
	genre,
	count(*) as genre_count
FROM
	genre AS g
INNER JOIN
	movie AS m
	ON g.movie_id = m.id
GROUP BY
	genre
ORDER BY genre_count DESC
LIMIT 1;

/*
+-------+-------------+
| genre | genre_count |
+-------+-------------+
| Drama |        4285 |
+-------+-------------+
*/

/*
Drama genre has the highest number of movies produced.
The join is done if we need any details from movie table.
The query below will give same output without join.
*/

SELECT
	genre,
    COUNT(movie_id) AS genre_count
FROM genre
GROUP BY genre
ORDER BY genre_count DESC;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*)
FROM (
    SELECT
		movie_id
    FROM
		genre
    GROUP BY
		movie_id
    HAVING
		COUNT(genre) = 1
) AS single_genre_movies;

/*
+----------+
| COUNT(*) |
+----------+
|     3289 |
+----------+
*/

/*
There are a total of 3289 movies which belongs to single genre. 
If we need details from movie table like title or year or country, we can use the following query.
*/
    SELECT 
		m.id, m.title
    FROM 
		movie AS m
    JOIN 
		genre AS g ON m.id = g.movie_id
    GROUP BY 
		m.id
    HAVING COUNT(g.genre) = 1;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


SELECT
	g.genre, ROUND(AVG(m.duration), 2) AS avg_duration
FROM
	movie AS m
INNER JOIN
	genre AS g ON m.id = g.movie_id
GROUP BY
	g.genre;

-- The ROUND function is used to limit the decimals to 2 numbers.
/*
+-----------+--------------+
| genre     | avg_duration |
+-----------+--------------+
| Drama     |       106.77 |
| Fantasy   |       105.14 |
| Thriller  |       101.58 |
| Comedy    |       102.62 |
| Horror    |        92.72 |
| Family    |       100.97 |
| Romance   |       109.53 |
| Adventure |       101.87 |
| Action    |       112.88 |
| Sci-Fi    |        97.94 |
| Crime     |       107.05 |
| Mystery   |       101.80 |
| Others    |       100.16 |
+-----------+--------------+
*/



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


SELECT
	genre,
    COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre;

/*
+-----------+-------------+------------+
| genre     | movie_count | genre_rank |
+-----------+-------------+------------+
| Drama     |        4285 |          1 |
| Comedy    |        2412 |          2 |
| Thriller  |        1484 |          3 |
| Action    |        1289 |          4 |
| Horror    |        1208 |          5 |
| Romance   |         906 |          6 |
| Crime     |         813 |          7 |
| Adventure |         591 |          8 |
| Mystery   |         555 |          9 |
| Sci-Fi    |         375 |         10 |
| Fantasy   |         342 |         11 |
| Family    |         302 |         12 |
| Others    |         100 |         13 |
+-----------+-------------+------------+

Thriller movie has 3rd rank.
*/


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT
	MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
	MAX(median_rating) AS max_median_rating
FROM ratings;

/*
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
| min_avg_rating | max_avg_rating | min_total_votes | max_total_votes | min_median_rating | max_median_rating |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
|            1.0 |           10.0 |             100 |          725138 |                 1 |                10 |
+----------------+----------------+-----------------+-----------------+-------------------+-------------------+
*/

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

SELECT
	m.title,
    avg_rating,
    DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM
	movie as m
INNER JOIN
	ratings as r ON m.id = r.movie_id
LIMIT 10;

/*
+--------------------------------+------------+------------+
| title                          | avg_rating | movie_rank |
+--------------------------------+------------+------------+
| Kirket                         |       10.0 |          1 |
| Love in Kilnerry               |       10.0 |          1 |
| Gini Helida Kathe              |        9.8 |          2 |
| Runam                          |        9.7 |          3 |
| Fan                            |        9.6 |          4 |
| Android Kunjappan Version 5.25 |        9.6 |          4 |
| Yeh Suhaagraat Impossible      |        9.5 |          5 |
| Safe                           |        9.5 |          5 |
| The Brighton Miracle           |        9.5 |          5 |
| Shibu                          |        9.4 |          6 |
+--------------------------------+------------+------------+
*/



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
    median_rating, COUNT(movie_id) AS movie_count
FROM
    ratings
GROUP BY median_rating
ORDER BY median_rating;

/*
+---------------+-------------+
| median_rating | movie_count |
+---------------+-------------+
|             1 |          94 |
|             2 |         119 |
|             3 |         283 |
|             4 |         479 |
|             5 |         985 |
|             6 |        1975 |
|             7 |        2257 |
|             8 |        1030 |
|             9 |         429 |
|            10 |         346 |
+---------------+-------------+
Movies with a median rating of 7 is highest with 2257 movies.
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH most_hit_movies AS
(
	SELECT 
		m.production_company, 
		COUNT(m.id) AS movie_count,
		DENSE_RANK() OVER (ORDER BY COUNT(m.id) DESC) AS prod_company_rank
	FROM 
		movie AS m
	INNER JOIN 
		ratings AS r 
	ON 
		r.movie_id = m.id 
	WHERE 
		r.avg_rating > 8 
		AND m.production_company IS NOT NULL
	GROUP BY 
		m.production_company
)
SELECT * FROM most_hit_movies WHERE prod_company_rank = 1;

/*
+------------------------+-------------+-------------------+
| production_company     | movie_count | prod_company_rank |
+------------------------+-------------+-------------------+
| Dream Warrior Pictures |           3 |                 1 |
| National Theatre Live  |           3 |                 1 |
+------------------------+-------------+-------------------+
*/

-- It if fine if RANK() or DENSE_RANK() is used.
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- First we will find for movies releases in USA only

SELECT 
    g.genre, COUNT(*) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country = 'USA'
        AND MONTH(m.date_published) = 3
        AND m.year = 2017
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

/*
+----------+-------------+
| genre    | movie_count |
+----------+-------------+
| Drama    |          16 |
| Comedy   |           8 |
| Crime    |           5 |
| Horror   |           5 |
| Action   |           4 |
| Sci-Fi   |           4 |
| Thriller |           4 |
| Romance  |           3 |
| Fantasy  |           2 |
| Mystery  |           2 |
| Family   |           1 |
+----------+-------------+

We can also use year(m.date_published) instead of year in where condition which provides the same result.

The country column have value like 'USA', 'USA, UK, Hungary, Canada, Spain', 'Canada, Germany, USA' etc.
So when we give query as country = 'USA', the country column values with 'USA' with other countries can be missed.
We can use a reg expression to match all the possible country values with 'USA'
*/

SELECT 
    g.genre, COUNT(*) AS movie_count
FROM
    genre AS g
        INNER JOIN
    movie AS m ON m.id = g.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE
    m.country REGEXP '(^|,\\s*)USA($|,\\s*)'
        AND MONTH(m.date_published) = 3
        AND m.year = 2017
        AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;

/*
+-----------+-------------+
| genre     | movie_count |
+-----------+-------------+
| Drama     |          24 |
| Comedy    |           9 |
| Action    |           8 |
| Thriller  |           8 |
| Sci-Fi    |           7 |
| Crime     |           6 |
| Horror    |           6 |
| Mystery   |           4 |
| Romance   |           4 |
| Fantasy   |           3 |
| Adventure |           3 |
| Family    |           1 |
+-----------+-------------+
*/

/*
Instead of regular expression we can also use
WHERE
    (m.country like 'USA,%' OR m.country like '%, USA' OR m.country like '%, USA,%' OR m.country = 'USA')
        AND MONTH(m.date_published) = 3
        AND m.year = 2017
        AND r.total_votes > 1000
*/

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
    m.title, r.avg_rating, g.genre
FROM
    genre AS g
        INNER JOIN
    ratings AS r ON g.movie_id = r.movie_id
        INNER JOIN
    movie AS m ON m.id = g.movie_id
WHERE
    m.title LIKE 'The%' AND r.avg_rating > 8
ORDER BY avg_rating DESC;

/*
+--------------------------------------+------------+----------+
| title                                | avg_rating | genre    |
+--------------------------------------+------------+----------+
| The Brighton Miracle                 |        9.5 | Drama    |
| The Colour of Darkness               |        9.1 | Drama    |
| The Blue Elephant 2                  |        8.8 | Drama    |
| The Blue Elephant 2                  |        8.8 | Horror   |
| The Blue Elephant 2                  |        8.8 | Mystery  |
| The Irishman                         |        8.7 | Crime    |
| The Irishman                         |        8.7 | Drama    |
| The Mystery of Godliness: The Sequel |        8.5 | Drama    |
| The Gambinos                         |        8.4 | Crime    |
| The Gambinos                         |        8.4 | Drama    |
| Theeran Adhigaaram Ondru             |        8.3 | Action   |
| Theeran Adhigaaram Ondru             |        8.3 | Crime    |
| Theeran Adhigaaram Ondru             |        8.3 | Thriller |
| The King and I                       |        8.2 | Drama    |
| The King and I                       |        8.2 | Romance  |
+--------------------------------------+------------+----------+
*/



-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT 
    m.title, m.date_published, r.median_rating
FROM
    ratings AS r
        INNER JOIN
    movie AS m ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8
ORDER BY m.date_published;

/*
+------------------------------------------------------------+----------------+---------------+
| title                                                      | date_published | median_rating |
+------------------------------------------------------------+----------------+---------------+
| Too Much Info Clouding Over My Head                        | 2018-04-01     |             8 |
| Dukun                                                      | 2018-04-05     |             8 |
| Arábia                                                     | 2018-04-05     |             8 |
| A Quiet Place                                              | 2018-04-05     |             8 |
| Love, Simon                                                | 2018-04-06     |             8 |
....
....
....
| Gone Kesh                                                  | 2019-03-29     |             8 |
| Sweater                                                    | 2019-03-29     |             8 |
| Live from Dhaka                                            | 2019-03-29     |             8 |
| Notebook                                                   | 2019-03-29     |             8 |
+------------------------------------------------------------+----------------+---------------+
361 rows in set (0.01 sec)
*/

-- To get the count
SELECT 
    COUNT(*) AS total_count
FROM
    ratings AS r
        INNER JOIN
    movie AS m ON m.id = r.movie_id
WHERE
    m.date_published BETWEEN '2018-04-01' AND '2019-04-01'
        AND r.median_rating = 8
ORDER BY m.date_published;

/*
+-------------+
| total_count |
+-------------+
|         361 |
+-------------+
*/


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- We can have separate queries here
SELECT
	SUM(total_votes) AS vote_count
FROM
	movie AS m
		INNER JOIN 
        ratings AS r ON m.id = r.movie_id
WHERE m.languages REGEXP '(^|,\\s*)German($|,\\s*)';
	
SELECT
	SUM(total_votes) AS vote_count
FROM
	movie AS m
		INNER JOIN 
        ratings AS r ON m.id = r.movie_id
WHERE m.languages REGEXP '(^|,\\s*)Italian($|,\\s*)';

-- Instead of the above approach we can have user defined function

DELIMITER $$

CREATE FUNCTION get_vote_count_by_language(lang VARCHAR(255))
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE vote_count INT;

    SELECT
        SUM(total_votes)
    INTO
        vote_count
    FROM
        movie AS m
        INNER JOIN ratings AS r ON m.id = r.movie_id
    WHERE
        m.languages REGEXP CONCAT('(^|,\\s*)', lang, '($|,\\s*)');

    RETURN vote_count;
END$$

DELIMITER ;

-- Count of movies in German
SELECT get_vote_count_by_language('German') AS movie_count;

/*
+-------------+
| movie_count |
+-------------+
|     4418885 |
+-------------+
*/

-- Count of movies in Italian
SELECT get_vote_count_by_language('Italian') AS movie_count;

/*
+-------------+
| movie_count |
+-------------+
|     2559540 |
+-------------+
*/

-- German movies have more votes than Italian movies
-- Answer is Yes

-- Adding the average total votes query in below for reference


SELECT
	AVG(total_votes) AS vote_count
FROM
	movie AS m
		INNER JOIN 
        ratings AS r ON m.id = r.movie_id
WHERE m.languages REGEXP '(^|,\\s*)German($|,\\s*)';

/*
+------------+
| vote_count |
+------------+
| 13190.7015 |
+------------+
*/

SELECT
	AVG(total_votes) AS vote_count
FROM
	movie AS m
		INNER JOIN 
        ratings AS r ON m.id = r.movie_id
WHERE m.languages REGEXP '(^|,\\s*)Italian($|,\\s*)';

/*
+------------+
| vote_count |
+------------+
| 11960.4673 |
+------------+
*/


/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
    names;

/*
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/

-- or we can use count

SELECT
    COUNT(CASE WHEN name IS NULL THEN 1 END) AS name_nulls,
    COUNT(CASE WHEN height IS NULL THEN 1 END) AS height_nulls,
    COUNT(CASE WHEN date_of_birth IS NULL THEN 1 END) AS date_of_birth_nulls,
    COUNT(CASE WHEN known_for_movies IS NULL THEN 1 END) AS known_for_movies_nulls
FROM
    names;

/*
+------------+--------------+---------------------+------------------------+
| name_nulls | height_nulls | date_of_birth_nulls | known_for_movies_nulls |
+------------+--------------+---------------------+------------------------+
|          0 |        17335 |               13431 |                  15226 |
+------------+--------------+---------------------+------------------------+
*/


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_genres AS (
    SELECT
        g.genre,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM
        genre AS g
        INNER JOIN ratings AS r ON r.movie_id = g.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
),
top_movies AS (
	SELECT
		movie_id
	FROM ratings
	WHERE avg_rating > 8
),
top_directors AS (
    SELECT
        n.name,
        COUNT(*) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS director_rank
    FROM names AS n
    INNER JOIN director_mapping AS dm ON n.id = dm.name_id
    INNER JOIN genre AS g ON dm.movie_id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres WHERE genre_rank < 4) AND
          dm.movie_id IN (SELECT movie_id FROM top_movies)
    GROUP BY n.name
)
SELECT name,movie_count FROM top_directors WHERE director_rank < 4 LIMIT 3;

-- I have used rank instead of limit in the CTEs so that we won't miss out if any genres or directors with same number of movie count

/*
+---------------+-------------+
| name          | movie_count |
+---------------+-------------+
| James Mangold |           4 |
| Anthony Russo |           3 |
| Joe Russo     |           3 |
+---------------+-------------+
*/

-- I am using LIMIT to get the first three, but there are many directors with movie count 3 and 2
-- Adding the output below without limit

WITH top_genres AS (
    SELECT
        g.genre,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
    FROM
        genre AS g
        INNER JOIN ratings AS r ON r.movie_id = g.movie_id
    WHERE r.avg_rating > 8
    GROUP BY g.genre
),
top_movies AS (
	SELECT
		movie_id
	FROM ratings
	WHERE avg_rating > 8
),
top_directors AS (
    SELECT
        n.name,
        COUNT(*) AS movie_count,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS director_rank
    FROM names AS n
    INNER JOIN director_mapping AS dm ON n.id = dm.name_id
    INNER JOIN genre AS g ON dm.movie_id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM top_genres WHERE genre_rank < 4) AND
          dm.movie_id IN (SELECT movie_id FROM top_movies)
    GROUP BY n.name
)
SELECT * FROM top_directors WHERE director_rank < 4;

/*
+----------------------+-------------+---------------+
| name                 | movie_count | director_rank |
+----------------------+-------------+---------------+
| James Mangold        |           4 |             1 |
| Anthony Russo        |           3 |             2 |
| Joe Russo            |           3 |             2 |
| Soubin Shahir        |           3 |             2 |
| Michael Powell       |           2 |             3 |
| Emeric Pressburger   |           2 |             3 |
| Arshad Siddiqui      |           2 |             3 |
| Aaron K. Carter      |           2 |             3 |
| Tigmanshu Dhulia     |           2 |             3 |
| Mahesh Narayan       |           2 |             3 |
| Raj B. Shetty        |           2 |             3 |
| Tim Van Someren      |           2 |             3 |
| Marianne Elliott     |           2 |             3 |
| Sandeep Reddy Vanga  |           2 |             3 |
| Khalid Rahman        |           2 |             3 |
| Noah Baumbach        |           2 |             3 |
| Oskars Rupenheits    |           2 |             3 |
| Clarence Williams IV |           2 |             3 |
| Aditya Dhar          |           2 |             3 |
| Mandeep Benipal      |           2 |             3 |
| Madhu C. Narayanan   |           2 |             3 |
| Jeral Clyde Jr.      |           2 |             3 |
| Amr Gamal            |           2 |             3 |
| Prince Singh         |           2 |             3 |
| Manoj K. Jha         |           2 |             3 |
| Nitesh Tiwari        |           2 |             3 |
| Harsha               |           2 |             3 |
| H. Vinoth            |           2 |             3 |
+----------------------+-------------+---------------+
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
    n.name AS actor_name, COUNT(rm.movie_id) AS movie_count
FROM
    role_mapping AS rm
        INNER JOIN
    movie AS m ON m.id = rm.movie_id
        INNER JOIN
    ratings AS r ON m.id = r.movie_id
        INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE
    r.median_rating >= 8
        AND rm.category = 'ACTOR'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;

/*
+------------+-------------+
| actor_name | movie_count |
+------------+-------------+
| Mammootty  |           8 |
| Mohanlal   |           5 |
+------------+-------------+
*/


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


WITH prod_company_ranks AS
(
	SELECT
		m.production_company,
		SUM(r.total_votes) AS vote_count,
		DENSE_RANK() OVER(ORDER BY SUM(r.total_votes) DESC) AS prod_comp_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r ON m.id = r.movie_id
	GROUP BY m.production_company
)

SELECT * FROM prod_company_ranks WHERE prod_comp_rank <= 3;

/*
+-----------------------+------------+----------------+
| production_company    | vote_count | prod_comp_rank |
+-----------------------+------------+----------------+
| Marvel Studios        |    2656967 |              1 |
| Twentieth Century Fox |    2411163 |              2 |
| Warner Bros.          |    2396057 |              3 |
+-----------------------+------------+----------------+
*/



/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT
	n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
    DENSE_RANK() OVER(ORDER BY (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actor_rank
FROM
	movie AS m
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
    INNER JOIN
    role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE 
	rm.category = 'ACTOR' AND m.country REGEXP '(^|,\\s*)India($|,\\s*)'
GROUP BY n.name
HAVING COUNT(rm.movie_id) >= 5
LIMIT 1;

/*
+------------------+-------------+-------------+------------------+------------+
| actor_name       | total_votes | movie_count | actor_avg_rating | actor_rank |
+------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi |       23114 |           5 |             8.42 |          1 |
+------------------+-------------+-------------+------------------+------------+
*/

-- The top actor is Vijay Sethupathi with 5 movies and avg rating of 8.42
-- We can make this as CTE and do where we can use rank function also

-- With WHERE country='India'

SELECT
	n.name AS actor_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actor_avg_rating,
    DENSE_RANK() OVER(ORDER BY (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actor_rank
FROM
	movie AS m
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
    INNER JOIN
    role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE 
	rm.category = 'ACTOR' AND m.country = 'India'
GROUP BY n.name
HAVING COUNT(rm.movie_id) >= 5
LIMIT 1;

-- The above query also gives the same result.
/*
+------------------+-------------+-------------+------------------+------------+
| actor_name       | total_votes | movie_count | actor_avg_rating | actor_rank |
+------------------+-------------+-------------+------------------+------------+
| Vijay Sethupathi |       23114 |           5 |             8.42 |          1 |
+------------------+-------------+-------------+------------------+------------+
*/
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- I am using regular expression for both country and language
SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
    DENSE_RANK() OVER(ORDER BY (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
	movie AS m
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
    INNER JOIN
    role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE 
	rm.category = 'ACTRESS' AND m.country REGEXP '(^|,\\s*)India($|,\\s*)' AND m.languages REGEXP '(^|,\\s*)Hindi($|,\\s*)'
GROUP BY n.name
HAVING COUNT(rm.movie_id) >= 3
LIMIT 5;

-- Taapsee Pannu is the top actress in avg_rating of 7.74
/*
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Kriti Sanon     |       21967 |           3 |               7.05 |            2 |
| Divya Dutta     |        8579 |           3 |               6.88 |            3 |
| Shraddha Kapoor |       26779 |           3 |               6.63 |            4 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            5 |
+-----------------+-------------+-------------+--------------------+--------------+
*/

-- If we don't use regular expression
SELECT
	n.name AS actress_name,
    SUM(r.total_votes) AS total_votes,
    COUNT(rm.movie_id) AS movie_count,
    ROUND(SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes), 2) AS actress_avg_rating,
    DENSE_RANK() OVER(ORDER BY (SUM(r.avg_rating * r.total_votes) / SUM(r.total_votes)) DESC, SUM(r.total_votes) DESC) AS actress_rank
FROM
	movie AS m
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
    INNER JOIN
    role_mapping AS rm ON m.id = rm.movie_id
    INNER JOIN
    names AS n ON n.id = rm.name_id
WHERE 
	rm.category = 'ACTRESS' AND m.country = 'India' AND m.languages = 'Hindi'
GROUP BY n.name
HAVING COUNT(rm.movie_id) >= 3
LIMIT 5;

-- In this case also, Taapsee Pannu is the top actress in avg_rating of 7.74. But we only get 4 rows as output
-- as we have limited it to movies only in Hindi language
/*
+-----------------+-------------+-------------+--------------------+--------------+
| actress_name    | total_votes | movie_count | actress_avg_rating | actress_rank |
+-----------------+-------------+-------------+--------------------+--------------+
| Taapsee Pannu   |       18061 |           3 |               7.74 |            1 |
| Divya Dutta     |        8579 |           3 |               6.88 |            2 |
| Kriti Kharbanda |        2549 |           3 |               4.80 |            3 |
| Sonakshi Sinha  |        4025 |           4 |               4.18 |            4 |
+-----------------+-------------+-------------+--------------------+--------------+
*/


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT
	m.id,
    m.title,
    r.avg_rating,
    CASE
		WHEN r.avg_rating > 8
			THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 AND 8
			THEN 'Hit Movies'
		WHEN r.avg_rating BETWEEN 5 AND 7
			THEN 'One-time-watch movies'
		ELSE 'Flop movies'
	END AS movie_category
FROM
	movie AS m
    INNER JOIN
    genre AS g ON m.id = g.movie_id
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE g.genre = 'Thriller';

/*
+------------+---------------------------------------------------------------+------------+-----------------------+
| id         | title                                                         | avg_rating | movie_category        |
+------------+---------------------------------------------------------------+------------+-----------------------+
| tt0012494  | Der müde Tod                                                  |        7.7 | Hit Movies            |
| tt0360556  | Fahrenheit 451                                                |        4.9 | Flop movies           |
| tt0837563  | Pet Sematary                                                  |        5.8 | One-time-watch movies |
| tt0862930  | Dukun                                                         |        6.9 | One-time-watch movies |
| tt0972544  | Back Roads                                                    |        7.0 | Hit Movies            |
| tt10039344 | Countdown                                                     |        5.4 | One-time-watch movies |
| tt10048556 | Staged Killer                                                 |        3.3 | Flop movies           |
| tt10055770 | Vellaipookal                                                  |        7.3 | Hit Movies            |
| tt10121762 | Uriyadi 2                                                     |        7.3 | Hit Movies            |
| tt10122392 | Incitement                                                    |        7.5 | Hit Movies            |
| tt10133300 | Rakshasudu                                                    |        8.4 | Superhit movies       |
....
....
| tt9816970  | Majaray Nimrooz: Radde Khoon                                  |        6.5 | One-time-watch movies |
| tt9817070  | Metri Shesh Va Nim                                            |        7.9 | Hit Movies            |
| tt9820594  | Misteri Dilaila                                               |        5.7 | One-time-watch movies |
| tt9855990  | Nightmare Tenant                                              |        5.5 | One-time-watch movies |
| tt9866700  | Paranormal Investigation                                      |        3.7 | Flop movies           |
| tt9894098  | Sathru                                                        |        6.1 | One-time-watch movies |
| tt9900782  | Kaithi                                                        |        8.9 | Superhit movies       |
| tt9903716  | Jessie                                                        |        7.2 | Hit Movies            |
+------------+---------------------------------------------------------------+------------+-----------------------+
*/

-- Get the count of each category
SELECT
    CASE
		WHEN r.avg_rating > 8
			THEN 'Superhit movies'
		WHEN r.avg_rating BETWEEN 7 AND 8
			THEN 'Hit Movies'
		WHEN r.avg_rating BETWEEN 5 AND 7
			THEN 'One-time-watch movies'
		ELSE 'Flop movies'
	END AS movie_category,
    COUNT(*) AS total_count
FROM
	movie AS m
    INNER JOIN
    genre AS g ON m.id = g.movie_id
    INNER JOIN
    ratings AS r ON m.id = r.movie_id
WHERE g.genre = 'Thriller'
GROUP BY movie_category;

/*
+-----------------------+-------------+
| movie_category        | total_count |
+-----------------------+-------------+
| Hit Movies            |         166 |
| Flop movies           |         493 |
| One-time-watch movies |         786 |
| Superhit movies       |          39 |
+-----------------------+-------------+
*/


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_durations AS
(
	SELECT
		g.genre,
        SUM(m.duration) AS total_duration,
		ROUND(AVG(m.duration), 2) AS avg_duration
	FROM
		movie AS m
		INNER JOIN
		genre AS g ON m.id = g.movie_id
	GROUP BY g.genre
	ORDER BY avg_duration DESC
)
SELECT
	genre,
    avg_duration,
    SUM(total_duration) OVER w AS running_total_duration,
    ROUND(AVG(avg_duration) OVER w, 2) AS moving_avg_duration
FROM
	genre_durations
WINDOW w AS (ORDER BY genre ROWS UNBOUNDED PRECEDING);

/*
+-----------+--------------+------------------------+---------------------+
| genre     | avg_duration | running_total_duration | moving_avg_duration |
+-----------+--------------+------------------------+---------------------+
| Action    |       112.88 |                 145506 |              112.88 |
| Adventure |       101.87 |                 205712 |              107.38 |
| Comedy    |       102.62 |                 453238 |              105.79 |
| Crime     |       107.05 |                 540271 |              106.11 |
| Drama     |       106.77 |                 997800 |              106.24 |
| Family    |       100.97 |                1028292 |              105.36 |
| Fantasy   |       105.14 |                1064250 |              105.33 |
| Horror    |        92.72 |                1176261 |              103.75 |
| Mystery   |       101.80 |                1232760 |              103.54 |
| Others    |       100.16 |                1242776 |              103.20 |
| Romance   |       109.53 |                1342014 |              103.77 |
| Sci-Fi    |        97.94 |                1378742 |              103.29 |
| Thriller  |       101.58 |                1529481 |              103.16 |
+-----------+--------------+------------------------+---------------------+
*/


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

WITH top_genres AS
(
	SELECT
		genre,
        COUNT(*) AS total_count
	FROM
		genre
	GROUP BY
		genre
	ORDER BY total_count DESC
    LIMIT 3
),
top_movies_with_clean_income AS
(
	SELECT
		g.genre,
		m.year,
		m.title AS movie_name,
		m.worlwide_gross_income AS worldwide_gross_income,
		CAST(REPLACE(worlwide_gross_income, '$', '') AS UNSIGNED INTEGER) AS worldwide_gross_income_cleaned
	FROM
		movie AS m
		INNER JOIN
		genre AS g ON m.id = g.movie_id
	WHERE g.genre IN (SELECT genre FROM top_genres)
),
top_movies_with_rank AS
(
	SELECT
		genre,
        year,
        movie_name,
        worldwide_gross_income,
        DENSE_RANK() OVER(PARTITION BY g.genre, m.year ORDER BY worldwide_gross_income_cleaned DESC) AS movie_rank
	FROM
		top_movies_with_clean_income
)
SELECT * FROM top_movies_with_rank WHERE movie_rank <=5;

/*
+----------+------+---------------------------------------+------------------------+------------+
| genre    | year | movie_name                            | worldwide_gross_income | movie_rank |
+----------+------+---------------------------------------+------------------------+------------+
| Comedy   | 2017 | Despicable Me 3                       | $ 1034799409           |          1 |
| Comedy   | 2017 | Jumanji: Welcome to the Jungle        | $ 962102237            |          2 |
| Comedy   | 2017 | Guardians of the Galaxy Vol. 2        | $ 863756051            |          3 |
| Comedy   | 2017 | Thor: Ragnarok                        | $ 853977126            |          4 |
| Comedy   | 2017 | Sing                                  | $ 634151679            |          5 |
| Comedy   | 2018 | Deadpool 2                            | $ 785046920            |          1 |
| Comedy   | 2018 | Ant-Man and the Wasp                  | $ 622674139            |          2 |
| Comedy   | 2018 | Tang ren jie tan an 2                 | $ 544061916            |          3 |
| Comedy   | 2018 | Ralph Breaks the Internet             | $ 529323962            |          4 |
| Comedy   | 2018 | Hotel Transylvania 3: Summer Vacation | $ 528583774            |          5 |
| Comedy   | 2019 | Toy Story 4                           | $ 1073168585           |          1 |
| Comedy   | 2019 | Pokémon Detective Pikachu             | $ 431705346            |          2 |
| Comedy   | 2019 | The Secret Life of Pets 2             | $ 429434163            |          3 |
| Comedy   | 2019 | Once Upon a Time... in Hollywood      | $ 371207970            |          4 |
| Comedy   | 2019 | Shazam!                               | $ 364571656            |          5 |
| Drama    | 2017 | Zhan lang II                          | $ 870325439            |          1 |
| Drama    | 2017 | Logan                                 | $ 619021436            |          2 |
| Drama    | 2017 | Dunkirk                               | $ 526940665            |          3 |
| Drama    | 2017 | War for the Planet of the Apes        | $ 490719763            |          4 |
| Drama    | 2017 | La La Land                            | $ 446092357            |          5 |
| Drama    | 2018 | Bohemian Rhapsody                     | $ 903655259            |          1 |
| Drama    | 2018 | Hong hai xing dong                    | $ 579220560            |          2 |
| Drama    | 2018 | Wo bu shi yao shen                    | $ 451183391            |          3 |
| Drama    | 2018 | A Star Is Born                        | $ 434888866            |          4 |
| Drama    | 2018 | Fifty Shades Freed                    | $ 371985018            |          5 |
| Drama    | 2019 | Avengers: Endgame                     | $ 2797800564           |          1 |
| Drama    | 2019 | The Lion King                         | $ 1655156910           |          2 |
| Drama    | 2019 | Joker                                 | $ 995064593            |          3 |
| Drama    | 2019 | Liu lang di qiu                       | $ 699760773            |          4 |
| Drama    | 2019 | It Chapter Two                        | $ 463326885            |          5 |
| Thriller | 2017 | The Fate of the Furious               | $ 1236005118           |          1 |
| Thriller | 2017 | Zhan lang II                          | $ 870325439            |          2 |
| Thriller | 2017 | xXx: Return of Xander Cage            | $ 346118277            |          3 |
| Thriller | 2017 | Annabelle: Creation                   | $ 306515884            |          4 |
| Thriller | 2017 | Split                                 | $ 278454358            |          5 |
| Thriller | 2018 | Venom                                 | $ 856085151            |          1 |
| Thriller | 2018 | Mission: Impossible - Fallout         | $ 791115104            |          2 |
| Thriller | 2018 | Hong hai xing dong                    | $ 579220560            |          3 |
| Thriller | 2018 | Fifty Shades Freed                    | $ 371985018            |          4 |
| Thriller | 2018 | The Nun                               | $ 365550119            |          5 |
| Thriller | 2019 | Joker                                 | $ 995064593            |          1 |
| Thriller | 2019 | Ne Zha zhi mo tong jiang shi          | $ 700547754            |          2 |
| Thriller | 2019 | John Wick: Chapter 3 - Parabellum     | $ 326667460            |          3 |
| Thriller | 2019 | Us                                    | $ 255105930            |          4 |
| Thriller | 2019 | Glass                                 | $ 246985576            |          5 |
+----------+------+---------------------------------------+------------------------+------------+
*/

-- We can change the order over year also.
-- Then our select statement after the CTE above will be
-- SELECT * FROM top_movies_with_rank WHERE movie_rank <=5 ORDER BY year,genre,movie_rank;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH prod_company_details AS
(
	SELECT
		m.production_company,
		COUNT(*) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS prod_comp_rank
	FROM
		movie AS m
		INNER JOIN
		ratings AS r ON m.id = r.movie_id
	WHERE
		r.median_rating >=8
		AND POSITION(',' IN languages) > 0
		AND m.production_company IS NOT NULL
	GROUP BY
		m.production_company
)
SELECT * FROM prod_company_details WHERE prod_comp_rank <= 2;


/*
+-----------------------+-------------+----------------+
| production_company    | movie_count | prod_comp_rank |
+-----------------------+-------------+----------------+
| Star Cinema           |           7 |              1 |
| Twentieth Century Fox |           4 |              2 |
+-----------------------+-------------+----------------+
*/


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_ranks AS
(
	SELECT
		n.name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(r.movie_id) AS movie_count,
        AVG(r.avg_rating) AS actress_avg_rating,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS actress_rank
	FROM
		names AS n
        INNER JOIN
        role_mapping AS rm ON n.id = rm.name_id
        INNER JOIN
        genre AS g ON g.movie_id = rm.movie_id
        INNER JOIN
        ratings AS r ON rm.movie_id = r.movie_id
	WHERE r.avg_rating > 8
		AND rm.category = 'ACTRESS'
        AND g.genre = 'Drama'
	GROUP BY
		n.name
)
SELECT * FROM actress_ranks LIMIT 3;

-- Giving LIMIT 3 as there are many actress with rank 1 and 2
-- We can use ROW_NUMBER also but it will display the row number even if they have same movie_count
/*
+---------------------+-------------+-------------+--------------------+--------------+
| actress_name        | total_votes | movie_count | actress_avg_rating | actress_rank |
+---------------------+-------------+-------------+--------------------+--------------+
| Parvathy Thiruvothu |        4974 |           2 |            8.20000 |            1 |
| Susan Brown         |         656 |           2 |            8.95000 |            1 |
| Amanda Lawrence     |         656 |           2 |            8.95000 |            1 |
+---------------------+-------------+-------------+--------------------+--------------+
*/




/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- The below approach has a detailed approach of having CTEs for each part.

WITH director_movie_counts AS (
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(dm.movie_id) AS number_of_movies
    FROM
        director_mapping dm
        INNER JOIN
        names n ON dm.name_id = n.id
    GROUP BY
        dm.name_id, n.name
    ORDER BY
        number_of_movies DESC
),
director_movies AS (
    SELECT
        dm.name_id AS director_id,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes
    FROM
        director_mapping dm
        INNER JOIN
        movie m ON dm.movie_id = m.id
        INNER JOIN
        ratings r ON m.id = r.movie_id
),
inter_movie_durations AS (
    SELECT
        director_id,
        movie_id,
        duration,
        avg_rating,
        total_votes,
        date_published,
        LAG(date_published) OVER (PARTITION BY director_id ORDER BY date_published) AS previous_date_published
    FROM
        director_movies
),
director_statistics AS (
    SELECT
        dmc.director_id,
        dmc.director_name,
        dmc.number_of_movies,
        ROUND(AVG(DATEDIFF(imd.date_published, imd.previous_date_published)), 2) AS avg_inter_movie_days,
        ROUND(AVG(imd.avg_rating), 2) AS avg_rating,
        SUM(imd.total_votes) AS total_votes,
        MIN(imd.avg_rating) AS min_rating,
        MAX(imd.avg_rating) AS max_rating,
        SUM(imd.duration) AS total_duration
    FROM
        director_movie_counts dmc
    INNER JOIN
        inter_movie_durations imd ON dmc.director_id = imd.director_id
    GROUP BY
        dmc.director_id, dmc.director_name, dmc.number_of_movies
)
SELECT
    *
FROM
    director_statistics
ORDER BY
    number_of_movies DESC,
    director_name
LIMIT 9;


/*
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm1777967   | A.L. Vijay        |                5 |               176.75 |       5.42 |        1754 |        3.7 |        6.9 |            613 |
| nm2096009   | Andrew Jones      |                5 |               190.75 |       3.02 |        1989 |        2.7 |        3.2 |            432 |
| nm0831321   | Chris Stokes      |                4 |               198.33 |       4.33 |        3664 |        4.0 |        4.6 |            352 |
| nm0425364   | Jesse V. Johnson  |                4 |               299.00 |       5.45 |       14778 |        4.2 |        6.5 |            383 |
| nm2691863   | Justin Price      |                4 |               315.00 |       4.50 |        5343 |        3.0 |        5.8 |            346 |
| nm6356309   | Özgür Bakar       |                4 |               112.00 |       3.75 |        1092 |        3.1 |        4.9 |            374 |
| nm0515005   | Sam Liu           |                4 |               260.33 |       6.23 |       28557 |        5.8 |        6.7 |            312 |
| nm0814469   | Sion Sono         |                4 |               331.00 |       6.03 |        2972 |        5.4 |        6.4 |            502 |
| nm0001752   | Steven Soderbergh |                4 |               254.33 |       6.48 |      171684 |        6.2 |        7.0 |            401 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/

-- We can combine director_movies and inter_movie_durations to one query as mentioned below which gives the same output.

WITH director_movies_with_rating AS (
    SELECT
        dm.name_id AS director_id,
        m.id AS movie_id,
        m.date_published,
        m.duration,
        r.avg_rating,
        r.total_votes,
        LAG(date_published) OVER (PARTITION BY dm.name_id ORDER BY date_published) AS previous_date_published
    FROM
        director_mapping dm
        INNER JOIN
        movie m ON dm.movie_id = m.id
        INNER JOIN
        ratings r ON m.id = r.movie_id
),
director_movie_counts AS (
    SELECT
        dm.name_id AS director_id,
        n.name AS director_name,
        COUNT(dm.movie_id) AS number_of_movies
    FROM
        director_mapping dm
        INNER JOIN
        names n ON dm.name_id = n.id
    GROUP BY
        dm.name_id, n.name
    ORDER BY
        number_of_movies DESC
),
director_statistics AS (
    SELECT
        dmc.director_id,
        dmc.director_name,
        dmc.number_of_movies,
        ROUND(AVG(DATEDIFF(dmr.date_published, dmr.previous_date_published)), 2) AS avg_inter_movie_days,
        ROUND(AVG(dmr.avg_rating), 2) AS avg_rating,
        SUM(dmr.total_votes) AS total_votes,
        MIN(dmr.avg_rating) AS min_rating,
        MAX(dmr.avg_rating) AS max_rating,
        SUM(dmr.duration) AS total_duration
    FROM
        director_movie_counts dmc
    INNER JOIN
        director_movies_with_rating dmr ON dmc.director_id = dmr.director_id
    GROUP BY
        dmc.director_id, dmc.director_name, dmc.number_of_movies
)
SELECT
    *
FROM
    director_statistics
ORDER BY
    number_of_movies DESC,
    director_name
LIMIT 9;

/*
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| director_id | director_name     | number_of_movies | avg_inter_movie_days | avg_rating | total_votes | min_rating | max_rating | total_duration |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
| nm1777967   | A.L. Vijay        |                5 |               176.75 |       5.42 |        1754 |        3.7 |        6.9 |            613 |
| nm2096009   | Andrew Jones      |                5 |               190.75 |       3.02 |        1989 |        2.7 |        3.2 |            432 |
| nm0831321   | Chris Stokes      |                4 |               198.33 |       4.33 |        3664 |        4.0 |        4.6 |            352 |
| nm0425364   | Jesse V. Johnson  |                4 |               299.00 |       5.45 |       14778 |        4.2 |        6.5 |            383 |
| nm2691863   | Justin Price      |                4 |               315.00 |       4.50 |        5343 |        3.0 |        5.8 |            346 |
| nm6356309   | Özgür Bakar       |                4 |               112.00 |       3.75 |        1092 |        3.1 |        4.9 |            374 |
| nm0515005   | Sam Liu           |                4 |               260.33 |       6.23 |       28557 |        5.8 |        6.7 |            312 |
| nm0814469   | Sion Sono         |                4 |               331.00 |       6.03 |        2972 |        5.4 |        6.4 |            502 |
| nm0001752   | Steven Soderbergh |                4 |               254.33 |       6.48 |      171684 |        6.2 |        7.0 |            401 |
+-------------+-------------------+------------------+----------------------+------------+-------------+------------+------------+----------------+
*/

