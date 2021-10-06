package com.estatjapan

import android.app.AlertDialog
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun onStart() {
//        print("bbbbbbb")
//        print(BuildConfig.DEBUG)
//        print(BuildConfig.BUILD_TYPE)
//        AlertDialog.Builder(this) // FragmentではActivityを取得して生成
//            .setTitle(BuildConfig.DEBUG.toString())
//            .setMessage(BuildConfig.AD_UNIT_ID)
//            .setPositiveButton("bOK", { dialog, which ->
//                // TODO:Yesが押された時の挙動
//            })
//            .show()
        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
            val TAG = "AAAA"
            if (!task.isSuccessful) {
                Log.w(TAG, "Fetching FCM registration token failed", task.exception)
                return@OnCompleteListener
            }

            // Get new FCM registration token
            val token = task.result

            // Log and toast
            if (token != null) {
                Log.d(TAG, token)
            }
        })
        super.onStart()
    }
}
