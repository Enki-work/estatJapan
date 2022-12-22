/*
 * Copyright 2019 Google LLC. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.estatjapan.purchase.utils

import android.content.res.Resources
import com.estatjapan.purchase.data.SubscriptionStatus

/**
 * Return the resource string for the basic subscription button.
 *
 * Add an asterisk if the subscription is not local and might not be modifiable on this device.
 */
fun basicTextForSubscription(res: Resources, subscription: SubscriptionStatus): String {
    return ""
}

/**
 * Return the resource string for the premium subscription button.
 *
 * Add an asterisk if the subscription is not local and might not be modifiable on this device.
 */
fun premiumTextForSubscription(res: Resources, subscription: SubscriptionStatus): String {
    return ""
}
