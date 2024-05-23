# Crowdfunding System API Documentation

## Overview
This documentation will include descriptions of the core functions, their parameters, return values, and usage examples. A simple crowdfunding system based on smartcontracts with the following key features:

1. **Campaign Management**: Create, update, and delete campaigns.
2. **Supporters Management**: Users can support their favorite campaings by pledging money to campaigns.
3. **Claiming or devolution**: User registration, login, and profile management.
4. **Reward Management**: Manage rewards for campaigns.


API documentation:

## Functions

### 1. Campaign Management

#### `create_campaign`
Creates a new crowdfunding campaign.

**Parameters:**
- `title` (str): The title of the campaign.
- `description` (str): A detailed description of the campaign.
- `goal_amount` (float): The fundraising goal for the campaign.
- `creator_id` (int): The ID of the user creating the campaign.

**Returns:**
- `campaign_id` (int): The ID of the newly created campaign.

**Example Usage:**
```python
campaign_id = create_campaign("New Tech Gadget", "An innovative new tech gadget.", 50000.0, 1)
```

#### `update_campaign`
Updates the details of an existing campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign to update.
- `title` (str, optional): The new title of the campaign.
- `description` (str, optional): The new description of the campaign.
- `goal_amount` (float, optional): The new fundraising goal for the campaign.

**Returns:**
- `success` (bool): Whether the update was successful.

**Example Usage:**
```python
success = update_campaign(1, title="Updated Tech Gadget", goal_amount=60000.0)
```

#### `delete_campaign`
Deletes a campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign to delete.

**Returns:**
- `success` (bool): Whether the deletion was successful.

**Example Usage:**
```python
success = delete_campaign(1)
```

### 2. Pledging System

#### `create_pledge`
Creates a new pledge to a campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign to pledge to.
- `user_id` (int): The ID of the user making the pledge.
- `amount` (float): The amount of money pledged.

**Returns:**
- `pledge_id` (int): The ID of the newly created pledge.

**Example Usage:**
```python
pledge_id = create_pledge(1, 2, 100.0)
```

#### `get_pledges_by_campaign`
Retrieves all pledges for a specific campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign.

**Returns:**
- `pledges` (list of dict): A list of pledges, where each pledge is represented by a dictionary containing `pledge_id`, `user_id`, and `amount`.

**Example Usage:**
```python
pledges = get_pledges_by_campaign(1)
```

### 3. User Management

#### `register_user`
Registers a new user.

**Parameters:**
- `username` (str): The username of the new user.
- `email` (str): The email address of the new user.
- `password` (str): The password of the new user.

**Returns:**
- `user_id` (int): The ID of the newly registered user.

**Example Usage:**
```python
user_id = register_user("johndoe", "john@example.com", "securepassword123")
```

#### `login_user`
Logs in a user.

**Parameters:**
- `email` (str): The email address of the user.
- `password` (str): The password of the user.

**Returns:**
- `token` (str): A session token for the logged-in user.

**Example Usage:**
```python
token = login_user("john@example.com", "securepassword123")
```

### 4. Reward Management

#### `create_reward`
Creates a new reward for a campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign.
- `description` (str): A description of the reward.
- `amount` (float): The pledge amount required to receive the reward.

**Returns:**
- `reward_id` (int): The ID of the newly created reward.

**Example Usage:**
```python
reward_id = create_reward(1, "Early Bird Special", 50.0)
```

#### `get_rewards_by_campaign`
Retrieves all rewards for a specific campaign.

**Parameters:**
- `campaign_id` (int): The ID of the campaign.

**Returns:**
- `rewards` (list of dict): A list of rewards, where each reward is represented by a dictionary containing `reward_id`, `description`, and `amount`.

**Example Usage:**
```python
rewards = get_rewards_by_campaign(1)
```

---

This documentation covers the core internal functions for managing a crowdfunding system. Each function includes a description, parameters, return values, and an example of how to use it. This should provide a solid foundation for developers working with the crowdfunding system's internal API.