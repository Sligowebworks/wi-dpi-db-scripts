select isnull(Year, 'ALL') as Year, 
ISNULL(Fullkey, 'XXXXXXXXXXXX') as Fullkey, 
IsNull(Race, 9) as Race,
Isnull(Sex,9) as Sex,
Isnull(IntentCode,'AL') as IntentCode,
Sum(Grads) as Grads
from post
Group BY 
Year, FullKey, RACE, SEX, IntentCode  
WITH CUBE