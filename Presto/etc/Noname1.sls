{% from Presto import map.jinja with content %}
{% set Presto_name=presto-server-0.179 %}
{% set Presto_PATH=/etc/presto/{{ Presto_name }} %}
{% set Presto_conf=config.properties %}

{% for role in pillar.get['Presto_lst'] %}
{{ Presto_PATH }}/etc:
  file.recurse:
    - source: salt://Presto/etc/{{ Presto_name }}
    - template: jinja
    - user: root
    - group: root
    - mode: 755
  file.managed:
    - source: salt://Presto/{{ role }}/{{ Presto_conf }}
    - template: jinja
    - user: root
    - group: root
    - mode: 640
{% endfor %}