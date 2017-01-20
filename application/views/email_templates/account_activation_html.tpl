<html>
<body>
<h3>{{ subject }}</h3>
<p>
    Please click the link below to activate your account and set your password for your phpMyAnsibleAdmin account on {{ site_url }}.
</p>
<p>
    <a href="{{ activation_link }}">{{ activation_link }}</a>
</p>
<br>
{% if from_name is not empty %}
<p>
    Sincerely,<br>
    {{ from_name }}
</p>
{% endif %}
</body>
</html>