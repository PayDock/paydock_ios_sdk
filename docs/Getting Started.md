![PayDock iOS SDK](https://paydock.com/wp-content/uploads/2016/08/logo_v3.png)

PaydDock iOS SDK is a framework to work with client side features of PayDock in iOS applications.

- [Installation](#installation)
- [Usage](#usage)


## installation

### CocoaPods

To integrate PayDock into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'PayDock', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

then, add the following code in your AppDelegate's application didFinishLaunchingWithOptions

```swift
PayDock.setSecretKey(key: "{{your secret key}}")
PayDock.setPublicKey(key: "{{your public key}}")
```

## Usage


- [Token](#token)
- [Charge](#charge)
- [Customer](#customer)
- [Subscription](#subscription)
- [PaymentSource](#paymentsource)
- [Address](#address)
- [Custom Network](#custom-network)


all models in PayDock SDK have a properties name rawJSON. you can access the raw json which paydock returned from api from this property.


#### Token

One-time token represents payment source information including Credit Сards or Direct Debit account details. It is a disposable token for creating charges/subscriptions/customers or updating customers

- [Create One-Time Token](#create-one-time-token)
- [Create A TokenRequest](#create-a-tokenrequest)


###### Create One-Time Token


```swift
PayDock.shared.create(token: TokenRequest) { (tokenResponse) in
    do {
        let tokenString = try tokenResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Create A TokenRequest

a TokenRequest instance is needed for getting a one-time token from PayDock.

```swift
let tokenRequest = TokenRequest(customer: CustomerRequest?, address: Address?, paymentSource: PaymentSource)
```
#### Charge

You can create a charge using which can be created from PaymentSource init:

- one-time token
- credit card details
- direct debit details, using bank account or BSB
- an existing customer
- an existing customer with non-default payment source

For a one time charge, payments are made using a one-time token, credit card or direct debit. Otherwise if you are making a payment for an existing customer, it’s simpler to store the payment source with the customer and make a payment using the customer ID.

- [Add Charge](#add-charge)
- [Get Charge Item Detail](#get-charge-item-detail)
- [Get Charge List](#get-charge-list)
- [Refund A Charge](#refund-a-charge)
- [Archive A Charge](#archive-a-charge)
- [Create A ChargeRequest](#create-a-chargerequest)

###### Add Charge

to add a charge you can use following code. [ChargeRequest](#create-a-chargerequest) is a parameter Model which have different init for different types of charges.

```swift
PayDock.shared.add(charge: ChargeRequest) { (chargeResponse) in
    do {
        let createdCharge = try chargeResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Get Charge Item Detail

get a charge item detail with charge's id

```swift
PayDock.shared.getCharge(with: {{id}}) { (chargeResponse) in
    do {
        let charge = try chargeResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Get Charge List
get a list of charges with parameter. use nil for ListParameters to get default first 100 charges

```swift
 let listParameters = ListParameters(skip: Int?, limit: Int?, subscription_id: String?, gateway_id: String?, company_id: String?, createdAtFrom: Date?, createdAtTo: Date?, search: String?, status: String?, isArchived: Bool?)
PayDock.shared.getCharges(with: listParameters) { (chargesResponse) in
    do {
        let chargeList = try chargesResponse()

    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Refund A Charge

refund a charge for specific amount.

```swift
PayDock.shared.refundCharge(with: {{id}}, amount: Float) { (chargeResponse) in
    do {
        let refundedCharge = try chargeResponse()
    } catch let error {
        print(error)
    }
}
```


###### Archive A Charge

archive a charge using it's id

```swift
PayDock.shared.archiveCharge(with: {{id}}) { (chargeResponse) in
    do {
        let refundedCharge = chargeResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```
###### Create A ChargeRequest

a ChargeRequest instance is needed for adding charge to PayDock.

```swift
// creating ChargeRequest for Charging with Credit Card or BankAccount
let withCreditCardOrBankAcc = ChargeRequest(amount: Float, currency: "AUD", reference: String?, description: String?, customer: CustomerRequest)
// creating ChargeRequest for Charging with PayDock Customer ID
let withCustomerId = ChargeRequest(amount: Float, currency: "AUD", reference: String?, description: String?, customerId: {{Paydock Customer ID}})
// creating ChargeRequest for Charging with non-default payment source
let withNonDefaultPaymentSource = ChargeRequest(amount: Float, currency: "AUD", reference: String?, description: String?, customerId: {{ Paydock Customer ID }}, paymentSourceId: {{ Payment Source ID}})
// creating ChargeRequest for Charging with one-time token
let withOneTimeToken = ChargeRequest(amount: Float, currency: "AUD", token: {{ one-time token }}, reference: String?, description: String?, email: String?)
```


#### Customer

A customer represents an individual who can make payments. Through the use of vaulted tokens, Customers can be store one or more payment sources, so that payment information doesn’t need to be collected again. Customers can also be associated with Subscriptions and can have Charges added against them.

A customer must have at least one payment source (eg. credit card) that can be used for payment.

- [Add A Customer](#add-a-customer)
- [Get A Customer Item Detail](#get-a-customer-item-detail)
- [Get Customer List](#get-customer-list)
- [Update A Customer](#update-a-customer)
- [Archive A Customer](#archive-a-customer)
- [Create A CustomerRequest](#create-a-customerrequest)


You can create a customer using which can be created from PaymentSource init:

- one-time token
- credit card details
- direct debit details, using bank account or BSB

###### Add A Customer

to add a customer you can use following code. [CustomerRequest](#create-a-customerrequest) is a parameter Model which have different init for different types of customers.

```swift
PayDock.shared.add(customer: CustomerRequest) { (customerResponse) in
   do {
       let addedCustomer = try customerResponse()
   } catch let error {
       print(error.localizedDescription)
   }
}
```
###### Get A Customer Item Detail

gets a customer item detail with customer's id

```swift
PayDock.shared.getCustomer(with: {{id}}) { (customerResponse) in
    do {
        let customer = try customerResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```
###### Get Customer List

gets a list of customers with parameter. use nil for ListParameters to get default first 100 charges

```swift
let listParameters = ListParameters(skip: Int?, limit: Int?, subscription_id: String?, gateway_id: String?, company_id: String?, createdAtFrom: Date?, createdAtTo: Date?, search: String?, status: String?, isArchived: Bool?)
PayDock.shared.getCustomers(with: listParameters) { (customersResponse) in
    do {
        let customerList = try customersResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```
###### Update A Customer

updates existing customer on PayDock

```swift
PayDock.shared.update(customer: CustomerRequest, for: {{id}}) { (customerResponse) in
    do {
        let updatedCustomer = try customerResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Archive A Customer

archives existing customer on PayDock.

```swift
PayDock.shared.archiveCustomer(with: {{id}}) { (chargeResponse) in
  do {
    let archivedCharge = try chargeResponse()
    } catch let error {
      print(error.localizedDescription)
    }
}
```

###### Create A CustomerRequest

a CustomerRequest instance is needed for adding customer to PayDock.

```swift
// add customer with default payment source
let withPaymentSource = CustomerRequest(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, paymentSource: PaymentSource)
// add customer with one-time token
let withOneTimeToken = CustomerRequest(firstName: String?, lastName: String?, email: String?, reference: String?, phone: String?, token: String)
```

#### Subscription

Subscriptions are recurring billing events. These can be set up to take scheduled payments from a customer without having to re-enter the billing details.

In order to charge for a recurring subscription, it can be added with:

- credit card details or a bank account. This will also create a customer
- a customer id
- a one-time token. This will also create a customer
- Subscriptions can run on different intervals (ie daily, weekly, monthly etc) and frequencies (ie 'every X days’). You can also control the start date for a subscription.

Subscriptions can also be configured to end after:

- a certain number of transactions
- an amount (eg end before reaching $1000 or end after reaching $1000)
- a date

If a subscription is created without a customer ID, a new customer will be created and the customer ID will be returned in the response.

- [Add Subscription](#add-a-customer)
- [Get A Subscription Item Detail](#get-a-customer-item-detail)
- [Get Subscription List](#get-customer-list)
- [Update Subscription](#update-a-customer)
- [Delete Subscription](#archive-a-customer)
- [Create A SubscriptionRequest](#create-a-subscriptionrequest)

###### Add Subscription

to add a subscription you can use following code. [SubscriptionRequest](#create-a-subscriptionrequest) is a parameter Model which have different init for different types of subscriptions.

```swift
PayDock.shared.add(subscription: SubscriptionRequest) { (subscriptionResponse) in
    do {
        let createdSubscription = try subscriptionResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Get A Subscription Item Detail

gets a subscription item detail with subscription's id

```swift
PayDock.shared.getSubscription(with: {{id}}) { (subscriptionResponse) in
    do {
        let subscription = try subscriptionResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Get Subscription List

gets a list of subscriptions with parameter. use nil for ListParameters to get default first 100 charges

```swift
let listParameters = ListParameters(skip: Int?, limit: Int?, subscription_id: String?, gateway_id: String?, company_id: String?, createdAtFrom: Date?, createdAtTo: Date?, search: String?, status: String?, isArchived: Bool?)
PayDock.shared.getsubscriptions(with: listParameters) { (subscriptionsResponse) in
    do {
        let subscriptinList = try subscriptionsResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```

###### Update Subscription

updates existing subscription on PayDock

```swift
PayDock.shared.update(subscription: SubscriptionRequest, for: {{id}}) { (subscriptionResponse) in
   do {
       let updatedSubscription = try subscriptionResponse()
   } catch let error {
       print(error.localizedDescription)
   }
}
```

###### Delete Subscription

cancels existing subscription on PayDock

```swift
PayDock.shared.deleteSubscription(with: {{id}}) { (subscriptionResponse) in
    do {
        let deletedSubscription = try subscriptionResponse()
    } catch let error {
        print(error.localizedDescription)
    }
}
```
###### Create A SubscriptionRequest

a SubscriptionRequest instance is needed for adding customer to PayDock.

```swift
let schedule = Schedule(interval: String, frequency: Int, startDate: Date?, endDate: Date?, endAmountAfter: Float?, endAmountBefore: Float?, endAmountTotal: Float?, endTransactions: Int?)
// with CustomerRequest and PaymentSource inside CustomerRequest
let withPaymentSource = SubscriptionRequest(amount: Float, currency: String, reference: String?, description: String?, customer: CustomerRequest, schedule: schedule)
// with Customer ID
let withCustomerId = SubscriptionRequest(amount: Float, currency: String, reference: String?, description: String?, customerId: String, schedule: schedule)
// with one-time token
let withOneTimeToken = SubscriptionRequest(amount: Float, currency: String, reference: String?, description: String?, token: String, schedule: schedule)
// for updating a existing subscription
let forUpdate = SubscriptionRequest(amount: Float, currency: String, reference: String?, description: String?, schedule: schedule)
```

#### PaymentSource

PaymentSource is a Parameter Model which is Used to Create CustomerRequest and TokenRequest. PaymentSources can be CreditCards or BankAccount o BSB.

```swift
let creditCard = Card(gatewayId: String, name: String, number: String, expireMonth: Int, expireYear: Int, ccv: String?, address: Address?)
let paymentSource = PaymentSource.card(value: creditCard)

let bankAccount = BankAccount(gatewayId: String, accountNumber: String?, accountName: String?, bankName: String?, accountRouting: String?, holderType: String?, address: Address?, type: String?)
let paymentSource = PaymentSource.bankAccount(value: bankAccount)

let bsb = BSB(gatewayId: String, accountNumber: String?, accountName: String?, accountBSB: String)
let paymentSource = PaymentSource.bsb(value: bsb)
```

#### Address
Address is a Parameter Model which is used in PaymentSource and specify customer's address

```swift
let address = Address(line1: String?, line2: String?, city: String?, postcode: String?, state: String?, country: String?)
```

#### Custom Network

PayDock SDK support can be used with other network pods and class. all you have to do is create a class that adopts PayDockNetwork protocol. and use a new instance of PayDock class which accepts a PayDockNetwork as a parameter

```swift
 let customNetworkPayDock = PayDock(network: PayDockNetwork)
```
