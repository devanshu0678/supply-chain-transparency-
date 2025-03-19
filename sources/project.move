module SupplyChain::Tracking {
    use aptos_framework::signer;
    use std::string::String;
    
    struct Product has store, key {
        id: u64,
        name: String,
        owner: address,
    }
    
    public fun add_product(owner: &signer, id: u64, name: String) {
        let product = Product {
            id,
            name,
            owner: signer::address_of(owner),
        };
        move_to(owner, product);
    }
    
    public fun transfer_product(sender: &signer, receiver: address, id: u64) acquires Product {
        let product = borrow_global_mut<Product>(signer::address_of(sender));
        assert!(product.id == id, 1);
        product.owner = receiver;
    }
}
