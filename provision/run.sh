#!/bin/bash
#
# Requires unzip

cd ..
mix ecto.create
mix ecto.migrate

cd provision

DATABASE_NAME=get_your_nutrients_dev

# download the USDA nutritional data
# wget https://www.ars.usda.gov/SP2UserFiles/Place/12354500/Data/SR/SR28/dnload/sr28asc.zip

# unzip package.zip
unzip sr28asc.zip

# Transform data to psv (pipe separated values)
python3 data-import.py -i FD_GROUP.txt  -o /tmp/FD_GROUP.psv
python3 data-import.py -i FOOD_DES.txt  -o /tmp/FOOD_DES.psv
# python3 data-import.py -i LANGDESC.txt  -o /tmp/LANGDESC.psv
# python3 data-import.py -i LANGUAL.txt   -o /tmp/LANGUAL.psv
python3 data-import.py -i NUTR_DEF.txt  -o /tmp/NUTR_DEF.psv
# python3 data-import.py -i SRC_CD.txt    -o /tmp/SRC_CD.psv
# python3 data-import.py -i DERIV_CD.txt  -o /tmp/DERIV_CD.psv
# python3 data-import.py -i WEIGHT.txt    -o /tmp/WEIGHT.psv
# python3 data-import.py -i FOOTNOTE.txt  -o /tmp/FOOTNOTE.psv
# python3 data-import.py -i DATA_SRC.txt  -o /tmp/DATA_SRC.psv
# python3 data-import.py -i DATSRCLN.txt  -o /tmp/DATSRCLN.psv
python3 data-import.py -i NUT_DATA.txt  -o /tmp/NUT_DATA.psv

#Create the DB schema. Make sure the DB and name/role exist otherwise this will fail.
# psql -f schema.sql -U postgres -d $DATABASE_NAME

# Import the data
psql -f imports.sql -U postgres -d $DATABASE_NAME

# Delete all relevant files once we're finished
#ls *.txt *.pdf | xargs rm
#ls *.psv | xargs rm
