package com.estatjapan

import android.util.Log
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import pigeon.Pigeon

class MainActivity: FlutterActivity(), Pigeon.HostPurchaseModelApi {

    override fun onStart() {
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

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Pigeon.HostPurchaseModelApi.setup(flutterEngine.dartExecutor, this)
    }

    override fun getPurchaseModel(): Pigeon.PurchaseModel {
        val purchaseModel = Pigeon.PurchaseModel()
        purchaseModel.isPurchase = false
        return purchaseModel
    }
}
