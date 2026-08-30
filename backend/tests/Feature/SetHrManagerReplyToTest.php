<?php

namespace Tests\Feature;

use App\Listeners\SetHrManagerReplyTo;
use Illuminate\Mail\Events\MessageSending;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Symfony\Component\Mime\Email;
use Tests\TestCase;

class SetHrManagerReplyToTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();

        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->nullable();
        });

        Schema::create('roles', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('guard_name');
        });

        Schema::create('model_has_roles', function (Blueprint $table) {
            $table->unsignedBigInteger('role_id');
            $table->string('model_type');
            $table->unsignedBigInteger('model_id');
        });
    }

    protected function tearDown(): void
    {
        Schema::dropIfExists('model_has_roles');
        Schema::dropIfExists('roles');
        Schema::dropIfExists('users');

        parent::tearDown();
    }

    public function test_it_adds_the_hr_manager_as_reply_to(): void
    {
        $roleId = DB::table('roles')->insertGetId([
            'name' => 'hr_manager',
            'guard_name' => 'web',
        ]);
        $managerId = DB::table('users')->insertGetId([
            'name' => 'HR Manager',
            'email' => 'hr.manager@example.com',
        ]);
        DB::table('model_has_roles')->insert([
            'role_id' => $roleId,
            'model_type' => 'App\\Models\\User',
            'model_id' => $managerId,
        ]);

        $message = (new Email())->from('noreply@example.com')->to('employee@example.com');

        app(SetHrManagerReplyTo::class)->handle(new MessageSending($message));

        $replyTo = $message->getReplyTo();

        $this->assertCount(1, $replyTo);
        $this->assertSame('hr.manager@example.com', $replyTo[0]->getAddress());
        $this->assertSame('HR Manager', $replyTo[0]->getName());
    }

    public function test_it_leaves_email_sendable_when_there_is_no_hr_manager(): void
    {
        $message = (new Email())->from('noreply@example.com')->to('employee@example.com');

        app(SetHrManagerReplyTo::class)->handle(new MessageSending($message));

        $this->assertSame([], $message->getReplyTo());
    }
}
