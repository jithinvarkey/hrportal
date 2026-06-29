<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class Holiday extends Model {
    protected $fillable = ['name', 'date', 'end_date', 'is_recurring'];
    protected $casts    = ['date' => 'date', 'end_date' => 'date', 'is_recurring' => 'boolean'];
}
