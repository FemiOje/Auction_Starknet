use starknet::{ContractAddress};
#[starknet::interface]
pub trait IAuction<TContractState> {
    fn register_item(ref self: TContractState, item_name: felt252);

    fn unregister_item(ref self: TContractState, item_name: felt252);

    fn bid(ref self: TContractState, bidder: ContractAddress, item_name: felt252, amount: u32);

    fn get_highest_bidder(self: @TContractState, item_name: felt252) -> (ContractAddress, u32);

    fn is_registered(self: @TContractState, item_name: felt252) -> bool;
}

#[starknet::contract]
pub mod Auction {
    use super::IAuction;
    use starknet::storage::{StorageMapReadAccess, StorageMapWriteAccess, Map};
    use core::starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        bids: Map<felt252, u32>,
        register: Map<felt252, bool>,
        highest_bidder: ContractAddress,
    }


    //TODO Implement interface and events .. deploy contract
    #[abi(embed_v0)]
    impl AuctionContractImpl of IAuction<ContractState> {
        fn register_item(ref self: ContractState, item_name: felt252) {
            //check if item already exists in the register
            let item = self.register.read(item_name);
            assert!(item == false, "Item already exists");

            //if item doesn't exist, register item
            self.register.write(item_name, true);
        }

        fn unregister_item(ref self: ContractState, item_name: felt252) {
            assert!(self.register.read(item_name) == true, "Item does not exist in register.");
            self.register.write(item_name, false);
        }

        fn bid(ref self: ContractState, bidder: ContractAddress, item_name: felt252, amount: u32) {
            assert!(
                self.register.read(item_name) == true,
                "The item you are bidding for does not exist in the register."
            );
            self.bids.write(item_name, amount);
        }

        fn get_highest_bidder(self: @ContractState, item_name: felt252) -> (ContractAddress, u32) {
            (get_caller_address(), 50)
            // TODO implement
        }

        fn is_registered(self: @ContractState, item_name: felt252) -> bool {
            self.register.read(item_name)
        }
    }
}
