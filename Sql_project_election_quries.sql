--       1: TOTAL ELIGIBLE VOTERS
-- Purpose: Calculate the total number of eligible voters in the dataset. 


Select count(*) as total_voters
From voters;


--      2 : TOTAL VOTES REGISTERED
-- Purpose: Find the total number of votes cast in the election.

Select count(*) as total_votes
From votes;


--      3 : VOTER TURNOUT PERCENTAGE
-- Purpose: Determine the percentage of eligible voters who participated in the election.

Select 
		round(count(*) *100/(select count(*) from voters),2) as Voting_percentage
from votes;


--       4: CONSTITUENCIES WITH ABOVE AVERAGE VOTER AGE
-- Purpose: Identify constituencies where the average age of voters exceeds the overall average voter age.


Select c.constituency_name ,round(avg(v.age),2) as Average_age
From constituencies c Inner Join voters v 
On c.constituency_id = v.constituency_id
Group by c.constituency_name
having avg(age)>(
				  Select avg(age) 
                  From voters);
                  
                  
--      5 :  CANDIDATES RECEIVING ABOVE-PARTY-AVERAGE VOTES
-- Purpose: Find candidates who received more votes than the average votes received by candidates from their own party.

Select c.candidate_name ,
	   p.party_name,
       count(v.vote_id) as total_votes 
From candidates c Inner Join parties p 
On c.party_id = p.party_id Inner Join votes v
On c.candidate_id = v.candidate_id 
group by p.party_name,c.candidate_name,p.party_id
having  count(v.vote_id) > (
							 Select avg(candidates_votes) 
                             From (
									Select count(v1.vote_id) as candidates_votes
                                    From votes v1 Inner Join candidates c1 
                                    On v1.candidate_id = c1.candidate_id 
                                    where c1.party_id = p.party_id
									group by c1.candidate_id
                                    )as sub
                                    );


--       6: TOTAL VOTES PER CANDIDATE
-- Purpose: Display the number of votes each candidate received.

Select count(v.vote_id) as Total_votes ,
		c.candidate_name
from votes v inner join candidates c
On v.candidate_id = c.candidate_id
group by c.candidate_name
order by count(v.vote_id) desc;

--       7: VOTING PERCENTAGE PER CANDIDATE
-- Purpose: Calculate the vote share percentage for each candidate.

Select c.candidate_name,count(*) as Votes_gained,
Round(count(*) *100.0 /(select count(*) from votes),2) as Percentage
From candidates c inner join votes v 
On c.candidate_id= v.candidate_id 
Group by c.candidate_name
Order by count(*) desc ;


--       8: WINNING CANDIDATE IN EACH CONSTITUENCY
-- Purpose: Identify the candidate with the highest number of votes in each constituency.

With ranked_candidates As (
			 Select co.constituency_name,
					c.candidate_name,
                    count(vote_id) as total_votes,
                    rank() over(partition by co.constituency_name order by count(v.vote_id) desc) as rnk
                    From constituencies co Inner Join candidates c 
                    On co.constituency_id = c.constituency_id Inner join votes v
                    On c.candidate_id = v.candidate_id
                    Group by co.constituency_name,c.candidate_name
                    )
Select constituency_name,
		candidate_name as Winning_candidate,
        total_votes
from ranked_candidates 
Where rnk = 1 
Order by total_votes desc;

--       9: PARTY LEADING IN EACH CONSTITUENCY
-- Purpose: Determine the party with the most votes in each constituency.               

With leading_party As(
					Select p.party_name,
					co.constituency_name,
					count(v.vote_id) as total_votes,
					rank() over(partition by co.constituency_name order by count(v.vote_id) desc) as rnk
					From candidates c Inner Join constituencies co 
					On c.constituency_id = co.constituency_id
					Inner Join Parties p 
					On c.party_id = p.party_id
					Inner Join votes v
					On v.candidate_id = c.candidate_id
					Group by co.constituency_name,p.party_name
)
Select constituency_name,
	    party_name,
        total_votes
from leading_party
where rnk=1
Order by total_votes desc;


--      10: RUNNER-UP CANDIDATE IN EACH CONSTITUENCY
-- Purpose: Find the second-highest vote-getting candidate in each constituency.

With Runner_up As(

Select c.candidate_name,
	   co.constituency_name,
       count(v.vote_id) as total_votes,
       rank()over(partition by co.constituency_name order by count(v.voter_id)  desc) as rnk
From candidates c Inner join constituencies co 
On c.constituency_id = co.constituency_id 
Inner Join votes v
On c.candidate_id = v.candidate_id
group by co.constituency_name,c.candidate_name

)
Select constituency_name,
	   candidate_name as Runner_up,
       total_votes
From runner_up 
Where rnk=2;


--      11: VOTES BY GENDER
-- Purpose: Count the number of votes cast by voters of each gender.

Select v1.gender,
	   count(v2.vote_id) as total_votes
From voters v1 Inner Join votes v2
On v1.voter_id = v2.voter_id
group by v1.gender;

--      12: YOUNGEST AND OLDEST VOTERS WHO VOTED
-- Purpose: Identify the youngest and oldest voters who participated in the election.

With Youngest As(
			Select v1.voter_name as Youngest_voters,
				   v1.Age 
			From voters v1 Inner Join votes v2
			On v1.voter_id = v2.voter_id
			where v1.age =( Select min(age) 
							From voters Inner Join votes 
							On voters.voter_id = votes.voter_id )
					   ),
Oldest As(
			Select v1.voter_name as Oldest_voters ,
				   v1.Age 
			From voters v1 Inner Join votes v2
			On v1.voter_id = v2.voter_id
			where v1.age =( Select max(age) 
							From voters Inner Join votes 
							On voters.voter_id = votes.voter_id )
						)

Select y.* , o.* 
From youngest y Cross Join oldest o;


--      13: DISTRICT-WISE WINNING PARTY
-- Purpose: Determine the winning party in each district based on total votes received.

With Leading_parties As (

				Select d.District_name,
					   p.Party_name,
                       count(v.voter_id) as Total_votes,
                       rank() Over(partition by district_name Order by count(v.voter_id)) as rnk
                       
				From Candidates c Inner Join Votes v 
                On c.candidate_id = v.candidate_id 
				Inner Join Parties p 
                On p.party_id = c.party_id
                Inner Join Constituencies co 
                On co.constituency_id = c.constituency_id 
                Inner Join Districts d
                On co.district_id = d.district_id
                Group by d.district_name , p. Party_name 
                
			)
Select District_name,
	   Party_name,
       Total_votes
From Leading_parties
Where rnk = 1;

--      14: TOP 3 PARTIES BY VOTES
-- Purpose: List the top three political parties with the highest number of votes.

Select p.party_name as Top_3_Parties
From parties p Inner Join candidates c 
On p.party_id = c.party_id Inner Join votes v 
On v.candidate_id = c.candidate_id
Group by p.party_name
Order by count(v.vote_id) desc
Limit 3;

--      15: DISTRICT-WISE WINNING PARTY AND LEADER
-- Purpose: Identify the winning party and its leader in each district.

With party_leader As (
Select d.district_name,
	   p.party_name , 
	   p.leader_name,
       rank() over(partition by d.district_name order by count(v.vote_id) desc) as rnk
From parties p Inner Join candidates c 
On p.party_id = c.party_id
Inner Join votes v
On v.candidate_id = c.candidate_id 
Inner Join constituencies co 
On co.constituency_id = c.constituency_id 
Inner Join districts d 
On d.district_id = co.district_id 
group by d.district_name,p.party_name,p.leader_name
)
Select district_name,
	   party_name as winning_party,
       leader_name
From party_leader
Where rnk = 1;

--      16: VOTERS WHO DID NOT VOTE
-- Purpose: List all registered voters who did not cast their vote.

Select v1.voter_id,v1.voter_name
From voters v1 Left Join votes v2
On v1.voter_id = v2.voter_id
where vote_id Is Null;


--      17: VOTING PERCENTAGE BY AGE GROUP
-- Purpose: Calculate the voting percentage for different age groups.

Select "Voting Percentage " as Aspect,
		Round(Sum(case when age < 30 then 1 else 0 end)*100 /
														(Select count(voter_id) from voters),2) as "Below 30" ,
                                                        
       Round(Sum(case when age between 30 and 40 then 1 else 0 end )*100 /
														(Select count(voter_id) from voters),2) as "30 to 40 " ,
                                                        
        Round(Sum(case when age between 41 and 60 then 1 else 0 end)*100 /
														(Select count(voter_id) from voters),2 ) as "41 to 60",
                                                        
        Round(Sum(case when age >60 then 1 else 0 end) *100 /
														(Select count(voter_id) from voters) ,2 ) as "Above 60 "
                                                        
        
From voters v1 Inner Join votes v2 
On v1.voter_id = v2.voter_id ;


--      18: TOP 10 CANDIDATES BY VOTES (USING A VIEW)
-- Purpose: Display the top ten candidates with the highest number of votes, using a database view for reusability.


Create view vote_summary As 
					Select c.candidate_id,
						   c.candidate_name,
                           p.party_name,
                           count(v.vote_id) as total_votes

					From candidates c Inner Join votes v
                    On c.candidate_id = v.candidate_id Inner Join parties p 
                    On p.party_id = c.party_id
                    group by c.candidate_id,c.candidate_name ;

Select candidate_id,
	   candidate_name,
       total_votes
From 
vote_summary
order by total_votes desc
Limit 10 ;

--      19: WINNING PARTY IN EACH STATE
-- Purpose: Identify the party that secured the most votes in each state.

Select state_name as "State",
	   party_name as "Winning Party"
From   (
			Select  s.state_name ,
					p.party_name ,
					rank() over(partition by s.state_name order by count(v.vote_id)  desc ) as rnk
			From
			candidates c Inner Join constituencies co
			On c.constituency_id = co.constituency_id 
			Inner Join parties p 
			On p.party_id = c.party_id 
			Inner Join districts d
			On d.district_id = co.district_id
			Inner Join states s
			On s.state_id = d.state_id
			Inner Join votes v
			On v.candidate_id = c.candidate_id 

			Group by s.state_name,p.party_name 
            Order by count(vote_id) desc
				) as sub_state
Where rnk = 1  ;

--      20: RUNNER-UP PARTY AND LEADER OVERALL
-- Purpose: Find the party and its leader who ranked second overall in total votes received.

Select p.party_name as "Party Name",
	   p.leader_name as "Runner up",
       count(v.vote_id) as "Total votes"
From 
parties p Inner Join candidates c 
On p.party_id = c.party_id
Inner Join votes v 
On v.candidate_id = c.candidate_id 
Group by p.party_name,p.leader_name
Order by count(v.vote_id) desc
Limit 1 
Offset 1;



--      21: OVERALL WINNING PARTY AND LEADER
-- Purpose: Determine the party and leader with the highest total votes across the election.

Select p.party_name as "Winning Parties",
	   p.leader_name as "Winner",
       count(v.vote_id) as "Total votes"
From 
parties p Inner Join candidates c 
On p.party_id = c.party_id
Inner Join votes v 
On v.candidate_id = c.candidate_id 
Group by p.party_name,p.leader_name
Order by count(v.vote_id) desc
Limit 1 ;


--      22: OVERALL ELECTION RESULTS SUMMARY
-- Purpose: Present the final election results showing each party’s leader, total votes, and vote percentage.
       
Select p.party_name ,
	   p.leader_name,
	   count(v.vote_id) as Total_votes ,
       Round(count(v.vote_id) *100/
							 (Select count(vote_id) from votes),2 ) as Percentage
From 
	parties p Inner Join candidates c
    On p.party_id = c.party_id
    Inner Join votes v
    On v.candidate_id = c.candidate_id
Group by p.party_name,p.leader_name
order by count(v.vote_id) desc ;














