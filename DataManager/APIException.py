class APIException(Exception):
    def __init__(self, message):
        self.message = message

    def __str__(self):
        return "APIException: " + self.message