from django.db import models




class Attendance(models.Model):
    emp_code = models.CharField(null=False,max_length=100)
    name = models.CharField(max_length=255,null=False)
    date = models.DateField()
    time_in = models.TimeField()
    time_out = models.TimeField(null=True, blank=True)
    time_diff = models.DecimalField(default=0.00,decimal_places=2,max_digits=10)
    status = models.CharField(max_length=20, choices=[
        ('present', 'Present'),
        ('absent', 'Absent'),
        ('late', 'Late'),
        ('half_day', 'Half Day'),
        ('leave', 'Leave')
    ],default='absent')
    notes = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    is_late = models.BooleanField(default=True)
    dep_text = models.CharField(null=True,max_length=20)

    def obj(self):
        return {
            'id': self.id,
            'employee': self.emp_code,
            'date': self.date,
            'time_in': self.time_in,
            'time_out': self.time_out,
            'status': self.status,
            'notes': self.notes,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
            'is_late':self.is_late,
            'dept':self.dep_text
        }


    def __str__(self):
        return f"{self.emp_code} - {self.date}"

    class Meta:
        db_table = 'attendance'
        ordering = ['-date', '-time_in']
        unique_together = ['emp_code', 'date']
