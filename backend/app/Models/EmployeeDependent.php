<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class EmployeeDependent extends Model
{
    protected $fillable = ['employee_id', 'full_name', 'relationship', 'date_of_birth', 'nationality',
        'passport_number', 'passport_expiry', 'is_active'];
    protected $casts = ['date_of_birth' => 'date', 'passport_expiry' => 'date', 'is_active' => 'boolean'];
    public function employee() { return $this->belongsTo(Employee::class); }
}
