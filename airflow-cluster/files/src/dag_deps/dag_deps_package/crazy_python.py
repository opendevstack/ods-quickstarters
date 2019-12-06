class MessagingClass(object):

    def __init__(self, message):
        self.message = message
        pass

    def __str__(self):
        return "{0} {1}".format(type(self), self.message)
