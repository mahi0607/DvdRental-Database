-- Table: movie_review
CREATE TABLE IF NOT EXISTS public.movie_review
(
    review_id SERIAL PRIMARY KEY,
    film_id INT NOT NULL,
    customer_id INT NOT NULL,
    review_text TEXT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_date TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    CONSTRAINT movie_review_film_id_fkey FOREIGN KEY (film_id)
        REFERENCES public.film (film_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT movie_review_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- Table: staff_schedule
CREATE TABLE IF NOT EXISTS public.staff_schedule
(
    schedule_id SERIAL PRIMARY KEY,
    staff_id INT NOT NULL,
    work_date DATE NOT NULL,
    start_time TIME WITHOUT TIME ZONE NOT NULL,
    end_time TIME WITHOUT TIME ZONE NOT NULL,
    CONSTRAINT staff_schedule_staff_id_fkey FOREIGN KEY (staff_id)
        REFERENCES public.staff (staff_id) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS public.rental_history
(
    history_id SERIAL PRIMARY KEY,
    rental_id INT NOT NULL,
    rental_date TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    return_date TIMESTAMP WITHOUT TIME ZONE,
    customer_id INT NOT NULL REFERENCES public.customer(customer_id),
    film_id INT NOT NULL REFERENCES public.film(film_id),
    store_id INT NOT NULL,
    staff_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.film_recommendations
(
    recommendation_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES public.customer(customer_id),
    film_id INT NOT NULL REFERENCES public.film(film_id),
    recommendation_score DECIMAL(4, 2),
    last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);


CREATE TABLE IF NOT EXISTS public.late_fee
(
    fee_id SERIAL PRIMARY KEY,
    rental_id INT NOT NULL REFERENCES public.rental(rental_id),
    days_overdue INT NOT NULL,
    fee_amount DECIMAL(5, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Unpaid' CHECK (status IN ('Unpaid', 'Paid', 'Waived')),
    last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);


CREATE TABLE IF NOT EXISTS public.promotions
(
    promotion_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    discount_rate DECIMAL(3, 2) NOT NULL CHECK (discount_rate >= 0 AND discount_rate <= 1),
    last_update TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);



-- populate the data

INSERT INTO public.movie_review (film_id, customer_id, review_text, rating, review_date)
VALUES
  (1, 1, 'Incredible storytelling and memorable characters.', 5, '2024-01-10 10:00:00'),
  (1, 2, 'The special effects were top-notch!', 4, '2024-01-10 11:00:00'),
  (2, 1, 'A bit too slow to get going, but a great finish.', 3, '2024-01-10 12:00:00'),
  (2, 3, 'I loved the soundtrack more than the movie itself.', 4, '2024-01-10 13:00:00'),
  (1, 3, 'Would watch it again! Two thumbs up!', 5, '2024-01-10 14:00:00'),
  (3, 1, 'The acting was superb, brought the characters to life.', 4, '2024-01-10 15:00:00'),
  (4, 2, 'My kids loved it, a new family favorite.', 5, '2024-01-10 16:00:00'),
  (3, 2, 'Not as good as the original, but still worth a watch.', 3, '2024-01-10 17:00:00'),
  (2, 4, 'A solid entry in the sci-fi genre. Really made me think.', 4, '2024-01-10 18:00:00'),
  (2, 4, 'Decent movie, but I probably wouldnt watch it a second time.', 3, '2024-01-10 19:00:00');

 select * from public.rental;
 
 INSERT INTO public.staff_schedule (staff_id, work_date, start_time, end_time)
VALUES
  (1, '2024-03-10', '09:00', '17:00'),
  (1, '2024-03-11', '09:00', '17:00'),
  (1, '2024-03-12', '10:00', '18:00'),
  (1, '2024-03-13', '09:00', '17:00'),
  (1, '2024-03-14', '09:00', '17:00'),
  (2, '2024-03-10', '13:00', '21:00'),
  (2, '2024-03-11', '13:00', '21:00'),
  (2, '2024-03-12', '14:00', '22:00'),
  (2, '2024-03-13', '13:00', '21:00'),
  (2, '2024-03-14', '13:00', '21:00');

INSERT INTO public.rental_history (rental_id, rental_date, return_date, customer_id, film_id, store_id, staff_id)
VALUES
  (101, '2024-03-01 14:00:00', '2024-03-05 10:00:00', 1, 1, 1, 1),
  (102, '2024-03-02 16:00:00', '2024-03-06 12:00:00', 2, 2, 1, 1),
  (103, '2024-03-03 18:00:00', '2024-03-07 14:00:00', 3, 3, 2, 2),
  (104, '2024-03-04 20:00:00', '2024-03-08 16:00:00', 4, 4, 2, 2),
  (105, '2024-03-05 10:00:00', '2024-03-09 10:00:00', 5, 5, 1, 1),
  (106, '2024-03-06 12:00:00', '2024-03-10 12:00:00', 6, 1, 2, 2),
  (107, '2024-03-07 14:00:00', '2024-03-11 14:00:00', 7, 2, 1, 1),
  (108, '2024-03-08 16:00:00', '2024-03-12 16:00:00', 8, 3, 2, 2),
  (109, '2024-03-09 18:00:00', '2024-03-13 18:00:00', 9, 4, 1, 1),
  (110, '2024-03-10 20:00:00', '2024-03-14 20:00:00', 10, 5, 2, 2);





INSERT INTO public.film_recommendations (customer_id, film_id, recommendation_score, last_update)
VALUES
  (1, 10, 8.5, '2024-03-10 09:00:00'),
  (2, 15, 9.0, '2024-03-10 09:15:00'),
  (3, 20, 7.5, '2024-03-10 09:30:00'),
  (4, 25, 6.0, '2024-03-10 09:45:00'),
  (5, 30, 9.5, '2024-03-10 10:00:00'),
  (1, 35, 7.0, '2024-03-10 10:15:00'),
  (2, 40, 8.0, '2024-03-10 10:30:00'),
  (3, 45, 9.2, '2024-03-10 10:45:00'),
  (4, 50, 6.5, '2024-03-10 11:00:00'),
  (5, 55, 8.8, '2024-03-10 11:15:00');

INSERT INTO public.late_fee (rental_id, days_overdue, fee_amount, status, last_update)
VALUES
  (101, 2, 1.99, 'Unpaid', '2024-03-15 09:00:00'),
  (102, 1, 0.99, 'Unpaid', '2024-03-15 09:15:00'),
  (103, 3, 2.99, 'Unpaid', '2024-03-15 09:30:00'),
  (104, 5, 4.99, 'Unpaid', '2024-03-15 09:45:00'),
  (105, 2, 1.99, 'Unpaid', '2024-03-15 10:00:00'),
  (106, 4, 3.99, 'Unpaid', '2024-03-15 10:15:00'),
  (107, 1, 0.99, 'Unpaid', '2024-03-15 10:30:00'),
  (108, 6, 5.99, 'Unpaid', '2024-03-15 10:45:00'),
  (109, 2, 1.99, 'Unpaid', '2024-03-15 11:00:00'),
  (110, 7, 6.99, 'Unpaid', '2024-03-15 11:15:00');
  

INSERT INTO public.promotions (name, description, start_date, end_date, discount_rate, last_update)
VALUES
  ('Summer Bonanza', 'Discount on all summer blockbusters.', '2024-06-01', '2024-08-31', 0.20, NOW()),
  ('Weekend Special', 'Special rates for all movies during weekends.', '2024-05-01', '2024-05-03', 0.15, NOW()),
  ('Holiday Cheer', 'Enjoy the holiday season with classic movies.', '2024-12-20', '2025-01-05', 0.25, NOW()),
  ('RomCom Festival', 'Romantic Comedies at half price.', '2024-02-14', '2024-02-20', 0.50, NOW()),
  ('Sci-Fi September', 'Explore the universe with a 30% discount on all sci-fi movies.', '2024-09-01', '2024-09-30', 0.30, NOW()),
  ('Halloween Horrors', 'Spooky savings on horror films.', '2024-10-25', '2024-10-31', 0.35, NOW()),
  ('Thanksgiving Offer', 'Grateful for our customers with these great offers.', '2024-11-23', '2024-11-30', 0.20, NOW()),
  ('Back to School', 'Family-friendly films to enjoy together.', '2024-08-15', '2024-09-15', 0.10, NOW()),
  ('New Year New Movies', 'Start the year right with our selection of new releases.', '2025-01-01', '2025-01-31', 0.20, NOW()),
  ('Classic Film Series', 'Journey back in time with these classic films.', '2024-03-01', '2024-04-01', 0.40, NOW());

-- Get the list of all movies.
SELECT * FROM public.film;

-- Retrieve all film titles and their associated reviews and ratings.
SELECT f.title, mr.review_text, mr.rating 
FROM public.movie_review AS mr
JOIN public.film AS f ON mr.film_id = f.film_id;

-- UPDATE: Change the status of all late fees that are over 5 days overdue to 'Waived'.
UPDATE public.late_fee 
SET status = 'Waived' 
WHERE days_overdue > 5;

-- Calculate the total amount of late fees per customer.
SELECT c.first_name, c.last_name, SUM(lf.fee_amount) AS total_late_fees 
FROM public.late_fee AS lf
JOIN public.rental AS r ON lf.rental_id = r.rental_id
JOIN public.customer AS c ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

-- Insert a new promotion that gives a 10% discount for all films that have an average rating of 5.
INSERT INTO public.promotions (name, description, start_date, end_date, discount_rate, last_update)
SELECT 'Perfect Score Discount', 'A 10% discount for our highest-rated films.', '2024-07-01', '2024-07-31', 0.10, NOW()
FROM public.film
WHERE film_id IN (
  SELECT film_id 
  FROM public.movie_review
  GROUP BY film_id
  HAVING AVG(rating) = 5
);

-- Get a list of all staff members and their corresponding work hours for a particular date.
SELECT s.first_name, s.last_name, ss.work_date, ss.start_time, ss.end_time 
FROM public.staff AS s
JOIN public.staff_schedule AS ss ON s.staff_id = ss.staff_id
WHERE ss.work_date = '2024-03-10';

--Retrieve film titles along with the names of the customers who rented them.
SELECT f.title, c.first_name, c.last_name
FROM public.rental AS r
JOIN public.inventory AS i ON r.inventory_id = i.inventory_id
JOIN public.film AS f ON i.film_id = f.film_id
JOIN public.customer AS c ON r.customer_id = c.customer_id;



-- Remove a staff schedule entry.
DELETE FROM public.staff_schedule WHERE schedule_id = 1;

-- Add a new customer.
INSERT INTO public.customer (first_name, last_name, email, address_id, store_id, activebool)
VALUES ('Sam', 'Wilson', 'sam.wilson@example.com', 1, 1, true);

-- Update a customer's last name.
UPDATE public.customer SET last_name = 'Smith' WHERE customer_id = 1;
-----------------

-- Shows all movies rented by each customer.
CREATE VIEW public.view_customer_rentals AS
SELECT c.customer_id, c.first_name, c.last_name, f.title, r.rental_date
FROM public.customer AS c
JOIN public.rental AS r ON c.customer_id = r.customer_id
JOIN public.inventory AS i ON r.inventory_id = i.inventory_id
JOIN public.film AS f ON i.film_id = f.film_id;


SELECT * FROM public.view_customer_rentals;


-- Displays average ratings for each film.
CREATE VIEW public.view_film_ratings AS
SELECT f.film_id, f.title, AVG(mr.rating) AS average_rating
FROM public.film AS f
JOIN public.movie_review AS mr ON f.film_id = mr.film_id
GROUP BY f.film_id;

SELECT * FROM public.view_film_ratings;

-- Lists complete work schedules for all staff.
CREATE VIEW public.view_staff_schedules AS
SELECT s.staff_id, s.first_name, s.last_name, ss.work_date, ss.start_time, ss.end_time
FROM public.staff AS s
JOIN public.staff_schedule AS ss ON s.staff_id = ss.staff_id;

SELECT * FROM public.view_staff_schedules;



-- Summarizes the late fees owed by each customer.
CREATE VIEW public.view_late_fees_owed AS
SELECT c.customer_id, c.first_name, c.last_name, SUM(lf.fee_amount) AS total_late_fees
FROM public.late_fee AS lf
JOIN public.rental AS r ON lf.rental_id = r.rental_id
JOIN public.customer AS c ON r.customer_id = c.customer_id
GROUP BY c.customer_id;

SELECT * FROM public.view_late_fees_owed;


-- Shows active promotions.
CREATE VIEW public.view_current_promotions AS
SELECT p.promotion_id, p.name, p.description, p.start_date, p.end_date, p.discount_rate
FROM public.promotions AS p
WHERE p.start_date <= CURRENT_DATE AND p.end_date >= CURRENT_DATE;

SELECT * FROM public.view_current_promotions;

------


-- Retrieve staff schedules between two dates.
SELECT *
FROM public.view_staff_schedules
WHERE work_date BETWEEN '2024-03-10' AND '2024-03-14';

-- Find the total number of rentals for each film.
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM public.rental AS r
JOIN public.inventory AS i ON r.inventory_id = i.inventory_id
JOIN public.film AS f ON i.film_id = f.film_id
GROUP BY f.title;


-- List film name and its release yeat based on the ascending order of release year and title
SELECT title, release_year 
FROM public.film
ORDER BY release_year ASC, title ASC;

--  List films that have received an average rating above 4.
SELECT f.title, AVG(mr.rating) AS average_rating
FROM public.movie_review AS mr
JOIN public.film AS f ON mr.film_id = f.film_id
GROUP BY f.title
HAVING AVG(mr.rating) > 4;

-- Show promotions that are active in July 2024 and have a discount rate of at least 20%.
SELECT *
FROM public.promotions
WHERE start_date <= '2024-07-31'
AND end_date >= '2024-07-01'
AND discount_rate >= 0.20;

-- Find movie reviews that either have a 5-star rating or were written for film ID 1.
SELECT *
FROM public.movie_review
WHERE rating = 5
OR film_id = 1;


-- Retrieve all rentals that occurred in the three years of 2005 to 2008.
SELECT *
FROM public.rental
WHERE rental_date BETWEEN '2005-01-01' AND '2008-01-01';

--  Identify customers who have made more than 5 rentals.
SELECT customer_id, COUNT(rental_id) AS total_rentals
FROM public.rental
GROUP BY customer_id
HAVING COUNT(rental_id) > 5;

-- Find movies that are either rated 'PG' or have a length greater than 120 minutes.
SELECT *
FROM public.film
WHERE rating = 'PG' OR length > 120;
-- Determine the top 3 most reviewed films.
SELECT f.title, COUNT(mr.review_id) AS review_count
FROM public.film AS f
JOIN public.movie_review AS mr ON f.film_id = mr.film_id
GROUP BY f.title
ORDER BY review_count DESC
LIMIT 3;


-- Count the Number of Films
SELECT COUNT(*) AS total_films FROM public.film;

-- Average Rating of All Movies
SELECT AVG(rating) AS average_movie_rating FROM public.movie_review;

-- Total Number of Rentals for Each Customer
SELECT customer_id, COUNT(rental_id) AS total_rentals
FROM public.rental
GROUP BY customer_id;

-- Maximum Late Fee by Any Rental
SELECT MAX(fee_amount) AS max_late_fee FROM public.late_fee;

-- Average Length of All Films
SELECT AVG(length) AS average_film_length FROM public.film;

-- Count of Films by Rating
SELECT rating, COUNT(film_id) AS number_of_films
FROM public.film
GROUP BY rating;

-- Minimum and Maximum Replacement Cost of Films
SELECT MIN(replacement_cost) AS min_replacement_cost, MAX(replacement_cost) AS max_replacement_cost FROM public.film;

-- Average Recommendation Score for Each Film
SELECT film_id, AVG(recommendation_score) AS avg_recommendation_score
FROM public.film_recommendations
GROUP BY film_id;

-- Number of Staff Scheduled Each Day
SELECT work_date, COUNT(distinct staff_id) AS number_of_staff
FROM public.staff_schedule
GROUP BY work_date;

-- How active the review section is on a monthly basis:
SELECT 
  EXTRACT(YEAR FROM review_date) AS review_year,
  EXTRACT(MONTH FROM review_date) AS review_month,
  COUNT(review_id) AS total_reviews
FROM public.movie_review
GROUP BY review_year, review_month
ORDER BY review_year, review_month;


-----

-- Find the titles of films that have a higher replacement cost than the average replacement cost of all films.
SELECT title, replacement_cost 
FROM public.film 
WHERE replacement_cost > (
  SELECT AVG(replacement_cost) 
  FROM public.film
);

-- List the average rating of films along with their titles, but only include films that have at least one review.
SELECT f.title, avg_reviews.avg_rating
FROM public.film AS f
JOIN (
  SELECT film_id, AVG(rating) AS avg_rating
  FROM public.movie_review
  GROUP BY film_id
) AS avg_reviews ON f.film_id = avg_reviews.film_id;

-- Retrieve the title of each film along with the total number of rentals for that film.
SELECT title,
       (SELECT COUNT(*)
        FROM public.rental AS r
        JOIN public.inventory AS i ON r.inventory_id = i.inventory_id
        WHERE i.film_id = f.film_id) AS total_rentals
FROM public.film AS f;

-- Get the title of the film that was rented most recently.
SELECT title
FROM public.film
WHERE film_id = (
  SELECT i.film_id
  FROM public.rental AS r
  JOIN public.inventory AS i ON r.inventory_id = i.inventory_id
  ORDER BY r.rental_date DESC
  LIMIT 1
);

-- Display Customer Names with Their Latest Rental Date:
SELECT first_name, last_name,
       (SELECT r.rental_date
        FROM public.rental AS r
        WHERE r.customer_id = c.customer_id
        ORDER BY r.rental_date DESC
        LIMIT 1) AS latest_rental_date
FROM public.customer AS c;

-- Customer with Maximum Rentals
SELECT first_name, last_name
FROM public.customer
WHERE customer_id = (
    SELECT r.customer_id
    FROM public.rental AS r
    GROUP BY r.customer_id
    ORDER BY COUNT(r.rental_id) DESC
    LIMIT 1
);

-- Film with the Longest Duration in Inventory
SELECT title
FROM public.film
WHERE length = (
    SELECT MAX(length)
    FROM public.film AS f
    JOIN public.inventory AS i ON f.film_id = i.film_id
);


-- Highest Average Rating by Film Category
SELECT c.name
FROM public.category AS c
WHERE c.category_id = (
    SELECT fc.category_id
    FROM public.film_category AS fc
    JOIN public.film AS f ON fc.film_id = f.film_id
    JOIN public.movie_review AS mr ON f.film_id = mr.film_id
    GROUP BY fc.category_id
    ORDER BY AVG(mr.rating) DESC
    LIMIT 1
);


