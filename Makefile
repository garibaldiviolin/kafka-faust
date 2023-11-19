up:
	docker-compose up -d --build app

down:
	docker-compose down

logs:
	docker-compose logs -t -f app

rebuild:
	docker-compose up -d --build --force-recreate --no-deps

destroy:
	docker-compose down --rmi all -v --remove-orphans

test:
	docker-compose exec --workdir /home/appuser/tests -T app pytest -vv

coverage:
	docker-compose exec --workdir /home/appuser/tests -T app pytest -vv \
		--cov --cov-report=html

bash:
	docker-compose exec --workdir /home/appuser/app app /bin/bash

produce-kafka-message:
	docker-compose exec kafka bash -c \
	"echo '{\"from_name\": \"name\", \"to_name\": \"surname\"}' | \
	kafka-console-producer.sh --request-required-acks 1 --broker-list \
	localhost:9092 --topic hello-topic"
