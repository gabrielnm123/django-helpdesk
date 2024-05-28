FROM python:3.10-slim-bullseye
LABEL src=https://github.com/django-helpdesk/django-helpdesk

# RUN apt-get update && apt-get install -y \
#     build-essential \
#     libxml2-dev \
#     libxslt1-dev \
#     zlib1g-dev \
#     libjpeg-dev \
#     libfreetype6-dev \
#     libpq-dev \
#     postgresql-common \
#     postgresql-client \
#     cron \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -yqq \
   postgresql-common \
   postgresql-client \
   cron \
   git

COPY requirements.txt /opt/django-helpdesk/requirements.txt
COPY standalone/extra-requirements.txt /opt/django-helpdesk/standalone/extra-requirements.txt
RUN pip3 install -r /opt/django-helpdesk/requirements.txt
RUN pip3 install -r /opt/django-helpdesk/standalone/extra-requirements.txt
COPY . /opt/django-helpdesk
WORKDIR /opt/django-helpdesk
RUN pip3 install -e .

RUN echo "* * * * * root . /etc/env && /usr/local/bin/python3 /opt/django-helpdesk/standalone/manage.py get_email >> /var/log/cron.log 2>&1" > /etc/crontab
RUN chmod 0644 /etc/crontab
ENTRYPOINT sh /opt/django-helpdesk/standalone/entrypoint.sh
