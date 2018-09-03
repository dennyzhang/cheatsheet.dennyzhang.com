all:git-pull

git-pull:
	bash automate.sh git_pull

git-push:
	bash automate.sh git_push

refresh-wordpress:
	bash automate.sh refresh_wordpress

refresh-wordpress-all:
	MAX_DAYS=730 bash automate.sh refresh_wordpress

refresh-cheatsheet:
	bash automate.sh refresh_cheatsheet

refresh-link:
	bash automate.sh refresh_link

my_test:
	bash automate.sh my_test
