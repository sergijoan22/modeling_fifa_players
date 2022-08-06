import pandas as pd

df = pd.read_csv('players.csv')


df2 = df[['sofifa_id', 'short_name', 'long_name', 'overall', 'potential', 'player_positions', 'value_eur', 'wage_eur', 'dob', 'height_cm', 'weight_kg', 'club_name', 'league_name', 'league_level', 'club_jersey_number', 'club_loaned_from', 'club_joined', 'club_contract_valid_until', 'nationality_name', 'nation_jersey_number', 'preferred_foot', 'weak_foot', 'skill_moves', 'international_reputation', 'work_rate', 'body_type', 'release_clause_eur', 'pace', 'shooting', 'passing', 'dribbling', 'defending', 'physic','player_url', 'player_face_url' , 'club_logo_url' , 'club_flag_url', 'nation_flag_url']]

# only want the main position
df2['player_positions'] = df2['player_positions'].str.split(',').str[0]

print(df2.head(10))

df2.to_csv('jugadores.csv', index = False)