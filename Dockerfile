FROM neo4j:4.4.3-community

WORKDIR /var/lib/neo4j

COPY data/movies.csv data/users.csv data/ratings.csv ./import/

RUN mkdir scripts
COPY create_genre_nodes.cypher ./scripts
COPY split_train_test.cypher ./scripts
COPY init-neo4j.sh ./scripts

# Import data and create genre nodes and relationships
RUN neo4j-admin import \
    --database=movielens \
    --nodes=Movie=import/movies.csv \
    --nodes=User=import/users.csv \
    --relationships=RATE=import/ratings.csv
RUN sed -i '9s/#dbms.default_database=neo4j/dbms.default_database=movielens/' conf/neo4j.conf


# Start Neo4j (it will use the modified neo4j.conf)
CMD ["neo4j"]