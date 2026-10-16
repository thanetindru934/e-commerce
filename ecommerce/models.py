from django.db import models


class ContactMessage(models.Model):
    full_name = models.CharField(max_length=120)
    email = models.EmailField()
    content = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.full_name} - {self.email}"