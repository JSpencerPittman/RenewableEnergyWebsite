FROM heroku/heroku:22

RUN apt update -y
RUN apt upgrade -y

RUN apt install python3 libexpat1 -y

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt install python3-pip -y

RUN apt install libgdal-dev -y
ENV CPLUS_INCLUDE_PATH /usr/local/gdal
ENV C_INCLUDE_PATH /usr/local/gdal

RUN mkdir -p /code

WORKDIR /code

COPY requirements.txt /tmp/requirements.txt
RUN set -ex && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    rm -rf /root/.cache/
COPY . /code

RUN python setup_proj.py --no-key --no-delta

ENV SECRET_KEY "JO0OXEOhnN7AWhvmgi1V16wqKaCX6805ePIXQvPY6Wqh5It9UU"
RUN python manage.py collectstatic --noinput
RUN python manage.py migrate

EXPOSE 8000

CMD gunicorn REW.wsgi:application --bind 0.0.0.0:$PORT
