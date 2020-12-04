ship:
	bundle exec fastlane beta && git add . && git commit -m "$m" && git push
demo:
	echo "$m"