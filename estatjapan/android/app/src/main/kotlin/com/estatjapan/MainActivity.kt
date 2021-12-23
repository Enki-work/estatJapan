package com.estatjapan

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProviders
import com.android.billingclient.api.Purchase
import com.estatjapan.purchase.Constants
import com.estatjapan.purchase.billing.BillingClientLifecycle
import com.estatjapan.purchase.ui.BillingViewModel
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import pigeon.Pigeon

class MainActivity: FlutterFragmentActivity(), Pigeon.HostPurchaseModelApi {

    private val TAG = "MainActivity"
    private lateinit var billingViewModel: BillingViewModel
    private lateinit var billingClientLifecycle: BillingClientLifecycle

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Billing APIs are all handled in the this lifecycle observer.
        billingClientLifecycle = (application as MyApplication).billingClientLifecycle
        lifecycle.addObserver(billingClientLifecycle)


        // Register purchases when they change.
        billingClientLifecycle.purchaseUpdateEvent.observe(this, Observer {
            it?.let {
                registerPurchases(it)
            }
        })
        billingViewModel = ViewModelProviders.of(this).get(BillingViewModel::class.java)
        // Launch the billing flow when the user clicks a button to buy something.
        billingViewModel.buyEvent.observe(this, Observer {
            it?.let {
                val responseCode = billingClientLifecycle.launchBillingFlow(this, it)
                Log.i(TAG, "billingClientLifecycle launchBillingFlow $responseCode")
            }
        })

        // Open the Play Store when this event is triggered.
        billingViewModel.openPlayStoreSubscriptionsEvent.observe(this, Observer {
                    Log.i(TAG, "Viewing subscriptions on the Google Play Store")
                    val sku = it
                    val url = if (sku == null) {
                        // If the SKU is not specified, just open the Google Play subscriptions URL.
                        Constants.PLAY_STORE_SUBSCRIPTION_URL
                    } else {
                        // If the SKU is specified, open the deeplink for this SKU on Google Play.
                        String.format(Constants.PLAY_STORE_SUBSCRIPTION_DEEPLINK_URL, sku, (this as FragmentActivity).packageName)
            }
            val intent = Intent(Intent.ACTION_VIEW)
            intent.data = Uri.parse(url)
            startActivity(intent)
        })
    }
    override fun onStart() {
        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
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
        val baseSku = getSharedPreferences(Constants.PURCHASE_KEY, MODE_PRIVATE).getString(Constants.BASIC_SKU, "") ?: ""
        val purchaseModel = Pigeon.PurchaseModel()
        purchaseModel.isPurchase = baseSku.isNotEmpty()
        return purchaseModel
    }

    override fun getIsUsedTrial(): Boolean {
        return false
    }

    override fun requestPurchaseModel(): Boolean {
        billingClientLifecycle.reStartConnection()
        billingViewModel.buyBasic()
        return true
    }

    override fun restorePurchaseModel(): Boolean {
        billingClientLifecycle.reStartConnection()
        billingClientLifecycle.queryPurchases()
        return true
    }

    /**
     * Register SKUs and purchase tokens with the server.
     */
    private fun registerPurchases(purchaseList: List<Purchase>) {
        if (purchaseList.isEmpty()) {
            val purchaseModel = Pigeon.PurchaseModel()
            purchaseModel.isPurchase = false
            Pigeon.FlutterPurchaseModelApi(flutterEngine?.dartExecutor).sendPurchaseModel(purchaseModel) {
                Log.d(TAG, "FlutterPurchaseModelApi sendPurchaseModel")
                val sharedPreferences = getSharedPreferences(Constants.PURCHASE_KEY, MODE_PRIVATE)
                val editor = sharedPreferences.edit()
                editor.clear()
                editor.apply()
            }
            return
        }
        for (purchase in purchaseList) {
            val sku = purchase.skus[0]
            val purchaseToken = purchase.purchaseToken
            Log.d(TAG, "Register purchase with sku: $sku, token: $purchaseToken")
            val sharedPreferences = getSharedPreferences(Constants.PURCHASE_KEY, MODE_PRIVATE)
            val editor = sharedPreferences.edit()
            editor.putString(sku, purchaseToken)
            editor.apply()

            if (Constants.BASIC_SKU == sku) {
                val purchaseModel = Pigeon.PurchaseModel()
                purchaseModel.isPurchase = true
                Pigeon.FlutterPurchaseModelApi(flutterEngine?.dartExecutor).sendPurchaseModel(purchaseModel) {
                    Log.d(TAG, "FlutterPurchaseModelApi sendPurchaseModel")

                }
            }
        }
    }
}
