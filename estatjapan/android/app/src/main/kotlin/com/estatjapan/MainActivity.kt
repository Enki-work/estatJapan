package com.estatjapan

import android.app.AlertDialog
import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {

    override fun onStart() {
        print("bbbbbbb")
        print(BuildConfig.DEBUG)
        print(BuildConfig.BUILD_TYPE)
        AlertDialog.Builder(this) // FragmentではActivityを取得して生成
            .setTitle(BuildConfig.DEBUG.toString())
            .setMessage(BuildConfig.AD_UNIT_ID)
            .setPositiveButton("bOK", { dialog, which ->
                // TODO:Yesが押された時の挙動
            })
            .show()
        super.onStart()
    }
}
