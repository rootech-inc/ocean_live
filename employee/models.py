from django.db import models


class Company(models.Model):
    name = models.CharField(max_length=100, unique=True)
    address = models.TextField()
    city = models.CharField(max_length=100)
    country = models.CharField(max_length=100)
    postal_code = models.CharField(max_length=20)
    phone = models.CharField(max_length=20)
    email = models.EmailField(max_length=100)
    website = models.URLField(max_length=200, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def obj(self):
        return {
            'id': self.id,
            'name': self.name,
            'address': self.address,
            'city': self.city,
            'country': self.country,
            'postal_code': self.postal_code,
            'phone': self.phone,
            'email': self.email,
            'website': self.website,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    def __str__(self):
        return self.name

    class Meta:
        db_table = 'company'
        ordering = ['name']


class Department(models.Model):
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def obj(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    def __str__(self):
        return f"{self.company.name} - {self.name}"

    

    def obj(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'company': self.company.obj(),
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }


class Position(models.Model):
    title = models.CharField(max_length=100)
    description = models.TextField(blank=True)
    min_salary = models.DecimalField(max_digits=10, decimal_places=2)
    max_salary = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def obj(self):
        return {
            'id': self.id,
            'title': self.title,
            'description': self.description,
            'min_salary': self.min_salary,
            'max_salary': self.max_salary,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    def __str__(self):
        return f"{self.department} - {self.title}"

    


class Employee(models.Model):
    emp_code = models.CharField(max_length=20,unique=True)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100, unique=True)
    phone = models.CharField(max_length=20,unique=True)
    address = models.TextField()
    city = models.CharField(max_length=100)
    country = models.CharField(max_length=100)
    postal_code = models.CharField(max_length=20)
    company = models.ForeignKey(Company, on_delete=models.CASCADE, related_name='employees')
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name='employees')
    position = models.ForeignKey(Position, on_delete=models.CASCADE, related_name='employees')
    hire_date = models.DateField()
    salary = models.DecimalField(max_digits=10, decimal_places=2)
    is_active = models.BooleanField(default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)


    def obj(self):
        return {
            'id': self.id,
            
            'first_name': self.first_name,
            'last_name': self.last_name,
            'email': self.email,
            'phone': self.phone,
            'address': self.address,
            'city': self.city,
            'country': self.country,
            'postal_code': self.postal_code,
            'company': self.company.id,
            'department': self.department.id,
            'position': self.position.id,
            'hire_date': self.hire_date,
            'salary': self.salary,
            'is_active': self.is_active,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

    class Meta:
        db_table = 'employee'
        ordering = ['-created_at']


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
            'updated_at': self.updated_at
        }

    def __str__(self):
        return f"{self.emp_code} - {self.date}"

    class Meta:
        db_table = 'attendance'
        ordering = ['-date', '-time_in']
        unique_together = ['emp_code', 'date']
