#!/bin/bash
# Install extra deps from /opt/extra-deps.txt if it exists
pip install -r /opt/extra-dependencies.txt
cd /opt/django-helpdesk/standalone/

# Starting cron to check emails
printenv > /etc/env
env | awk -F= '{printf "export %s=\"%s\"\n", $1, $2}' > /etc/env
cron &&
python manage.py migrate --noinput                # Apply database migrations
python manage.py createsuperuser --noinput
python manage.py collectstatic --noinput

# Start Gunicorn processes
echo Starting Gunicorn.
exec gunicorn standalone.config.wsgi:application \
	   --name django-helpdesk \
	   --bind 0.0.0.0:${GUNICORN_PORT:-"8000"} \
	   --workers ${GUNICORN_NUM_WORKERS:-"6"} \
	   --timeout ${GUNICORN_TIMEOUT:-"60"} \
	   --preload \
	   --log-level=debug \
	   --log-file=- \
	   --access-logfile=- \
	   "$@"
