.PHONY: resetdb

resetdb:
	rails db:purge
	rails db:migrate
	rails db:seed
