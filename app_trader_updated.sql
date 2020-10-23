

SELECT a.name , a.primary_genre as app_primary_genre,  a.rating as app_rating, 
	   a.content_rating as app_content_rating,a.price as app_price,
       a.currency as app_currency,a.review_count as app_review_count, b.review_count as play_review_count,
	   b.genres as play_genre, b.rating as play_rating,b.price as play_price,
	   b.content_rating as play_content_rating,b.type as play_type,b.install_count as play_install_count,
	   --to calculate the cost of the apps
	   case when a.price=0 then 10000 
	   else a.price*10000 end as cost,
	   --longivity
	   case when a.rating=0 then 1
	    when a.rating=0.5 then 2
	    when a.rating=1 then 3
	    when a.rating=1.5 then 4
	    when a.rating=2 then 5
	    when a.rating=2.5 then 6
	    when a.rating=3 then 7
	    when a.rating=03.5then 8
	    when a.rating=4 then 9
	    when a.rating=4.5 then 10
	    when a.rating=5 then 11
		end as app_life
			    
	   	   
	   
FROM app_store_apps a
inner join play_store_apps b
on a.name = b.name


ORDER BY a.rating desc,play_install_count desc,app_review_count desc,play_review_count desc
limit 100 ;










WITH psa AS (SELECT DISTINCT name AS psa_name, category, price AS psa_price,rating AS psa_rating,
			 review_count AS psa_review_count
		  	 FROM play_store_apps
	 		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count > 100000
				AND category ILIKE 'Game'),
	 asa AS (SELECT DISTINCT name AS asa_name, primary_genre AS category , price AS asa_price,
			 rating AS asa_rating, review_count AS asa_review_count
	  		 FROM app_store_apps
  	  		 WHERE rating > 4
				AND price::money < 1:: money
				AND review_count::numeric > 100000
	 			AND primary_genre ILIKE 'Games')
SELECT psa_name, psa_price, psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
FROM psa
INNER JOIN asa on psa.psa_name = asa.asa_name
GROUP BY psa_name, psa_price,psa_rating,psa_review_count,asa_price,asa_rating,asa_review_count
ORDER BY psa_name
LIMIT 200;



